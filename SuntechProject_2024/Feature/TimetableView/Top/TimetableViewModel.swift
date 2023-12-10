//
//  TimetableViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/05.
//

import Foundation
import SwiftUI
import Combine

final class TimetableViewModel: ObservableObject {
    @Published private(set) var weekTimetable: WeekTimetable? = nil
    @Published private(set) var vacations: [Vacation] = []
    @Published private(set) var vacation: Vacation? = nil
    @Published private(set) var cancellClasses: [ClassCancellation] = []
    @Published private(set) var cancellClassesInWeek: [ClassCancellation] = []
    @Published private(set) var changeClasses: [ClassChange] = []
    @Published private(set) var changeClassesInWeek: [ClassChange] = []
    @Published private(set) var timetableInWeek: WeekTimetable? = nil
    @Published private(set) var isLoading: Bool = false
    @Published var apiError: Error? = nil
    @Published var today: Date = .now
    @Published var monday: Date = .now
    @Published var friday: Date = .now
    @Published var month: Int = Calendar.current.component(.month, from: .now)
    
    private var cancellables = Set<AnyCancellable>()
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    private let _navigationSubject = PassthroughSubject<Navigation, Never>()
    var navigationSignal: AnyPublisher<Navigation, Never> {
        _navigationSubject.eraseToAnyPublisher()
    }
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
        self.today = .now
        self.monday = today.getMondayOfWeek()
        self.friday = today.getFridayOfWeek()
        self.fetchVacations()
        self.fetchCancelClass()
        self.fetchChangeClass()
        
        $today
            .compactMap { $0 }
            .sink { [weak self] date in
                guard let self else { return }
                
                for vacation in self.vacations {
                    if VacationChecker.isVacationInToday(date, vacation: vacation) {
                        self.vacation = vacation
                        return
                    } else {
                        self.vacation = nil
                    }
                }
            }
            .store(in: &cancellables)
        
        $month
            .sink { [weak self] month in
                guard let self else { return }
                
                self.fetchWeekTimetable()
            }
            .store(in: &cancellables)
        
        Publishers.Zip($monday.compactMap { $0 }, $friday.compactMap { $0 })
            .sink { [weak self] monday, friday in
                guard let self else { return }
                
                for vacation in self.vacations {
                    if VacationChecker.isVacationInWeek(
                        today: today,
                        monday: monday,
                        friday: friday,
                        vacation: vacation) {
                        self.vacation = vacation
                        return
                    } else {
                        self.vacation = nil
                    }
                }
                
            }
            .store(in: &cancellables)
        
        // TODO: リファクタリングしたい
        // 週ごとの休講情報を取得するための処理
        Publishers.Zip($monday, $friday)
            .dropFirst(2)
            .sink { [weak self] monday, friday in
                guard let self else { return }
                self.cancellClassesInWeek = self.cancellClasses.filter { monday <= $0.date && $0.date <= friday}
            }
            .store(in: &cancellables)

        $cancellClasses
            .map { classes in
                classes.filter { [weak self] in
                    guard let self else { return false }
                    return self.monday <= $0.date && $0.date <= self.friday
                }
            }
            .assign(to: \.cancellClassesInWeek, on: self)
            .store(in: &cancellables)
        
//        👇この方法だとうまくいかず
//        $cancellClasses
//            .combineLatest($monday, $friday)
//            .map { classes, monday, friday in
//                classes.filter {
//                    return monday <= $0.date && $0.date <= friday
//                }
//            }
//            .assign(to: \.cancellClassesInWeek, on: self)
//            .store(in: &cancellables)
        
        // 週ごとの変更情報を取得するための処理
        Publishers.Zip($monday, $friday)
            .dropFirst(2)
            .sink { [weak self] monday, friday in
                guard let self else { return }
                self.changeClassesInWeek = self.changeClasses.filter { monday <= $0.beforeDate && $0.beforeDate <= friday}
            }
            .store(in: &cancellables)

        $changeClasses
            .map { classes in
                classes.filter { [weak self] in
                    guard let self else { return false }
                    return self.monday <= $0.beforeDate && $0.beforeDate <= self.friday
                }
            }
            .assign(to: \.changeClassesInWeek, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest($weekTimetable, $changeClassesInWeek)
            .map { [weak self] timetable, changeClasses in
                return self?.updateTimetableWithClassChanges(timetable, changeClasses)
            }
            .assign(to: \.timetableInWeek, on: self)
            .store(in: &cancellables)
        
    }
    
    func fetchWeekTimetable() {
        guard let currentUser = LoginUserInfo.shared.currentUser,
              let password = LoginUserInfo.shared.password,
              let student = currentUser.user as? Student else { return }

        if 4 <= month && month <= 8 { // 前期
            suntechAPIClient.fetchWeekTimetableFirst(studentId: student.id, password: password) { [weak self] result in
                switch result {
                case .success(let weekTimetable):
                    self?.weekTimetable = weekTimetable
                case .failure(let error):
                    print(error)
                }
            }
        } else { // 後期
            suntechAPIClient.fetchWeekTimetableSecond(studentId: student.id, password: password) { [weak self] result in
                switch result {
                case .success(let weekTimetable):
                    self?.weekTimetable = weekTimetable
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func hoge(dayTimetable: [DayTimetable], changeClasses: [ClassChange]) -> [DayTimetable] {
        var updateDayTimetable = dayTimetable
        for (index, timetableClass) in dayTimetable.enumerated() {
            if let change = changeClasses.filter({ $0.classId == timetableClass.classData.id }).first {
                updateDayTimetable[index] = DayTimetable(
                    period1: change.period1,
                    period2: change.period2,
                    classData: timetableClass.classData
                )
            }
        }
        return updateDayTimetable
    }
    
    func fetchVacations() {
        isLoading = true
        
        suntechAPIClient.fetchVacations { [weak self] result in
            switch result {
            case .success(let vacations):
                self?.vacations = vacations
            case .failure(let error):
                print(error)
            }
            self?.isLoading = false
        }
    }
    
    func fetchCancelClass() {
        suntechAPIClient.fetchCancelClass { [weak self] result in
            switch result {
            case .success(let cancellClasses):
                self?.cancellClasses = cancellClasses
            case .failure(let error):
                self?.apiError = error as Error
            }
        }
    }
    
    func fetchChangeClass() {
        suntechAPIClient.fetchChangeClass { [weak self] result in
            switch result {
            case .success(let changeClasses):
                self?.changeClasses = changeClasses
            case .failure(let error):
                self?.apiError = error as Error
            }
        }
    }
    
    func navigate(_ navigation: Navigation) {
        _navigationSubject.send(navigation)
    }
}

extension TimetableViewModel {
    /// タイムテーブルを更新するメインの関数
    private func updateTimetableWithClassChanges(_ timetable: WeekTimetable?, _ changeClasses: [ClassChange]) -> WeekTimetable? {
        guard let timetable = timetable else { return nil }

        var updatedTimetable = timetable
        let allDays = timetable.monday + timetable.tuesday + timetable.wednesday + timetable.thursday + timetable.friday

        // 変更がある場合、授業情報を更新
        if let changeClass = findFirstChangeClass(in: changeClasses, from: allDays) {
            if let existingClass = findExistingClass(for: changeClass, in: allDays) {
                removeExistingClassFromTimetable(&updatedTimetable, existingClass)
                addUpdatedClassToTimetable(&updatedTimetable, changeClass, existingClass)
            }
        }

        return updatedTimetable
    }
    /// 変更がある授業を検索する関数
    private func findFirstChangeClass(in changeClasses: [ClassChange], from allDays: [DayTimetable]) -> ClassChange? {
        return changeClasses.filter { changeClass in
            allDays.contains { day in
                changeClass.classId == day.classData.id
            }
        }.first
    }
    /// 変更がある授業に対応する元の授業を検索する関数
    private func findExistingClass(for changeClass: ClassChange, in allDays: [DayTimetable]) -> DayTimetable? {
        return allDays.filter { day in
            changeClasses.contains { change in
                day.classData.id == change.classId
            }
        }.first
    }
    /// タイムテーブルから授業を削除する関数
    private func removeExistingClassFromTimetable(_ timetable: inout WeekTimetable, _ existingClass: DayTimetable) {
        timetable.monday.removeAll(where: { $0.id == existingClass.id })
        timetable.tuesday.removeAll(where: { $0.id == existingClass.id })
        timetable.wednesday.removeAll(where: { $0.id == existingClass.id })
        timetable.thursday.removeAll(where: { $0.id == existingClass.id })
        timetable.friday.removeAll(where: { $0.id == existingClass.id })
    }
    /// タイムテーブルに新しい授業を追加する関数
    private func addUpdatedClassToTimetable(_ timetable: inout WeekTimetable, _ changeClass: ClassChange, _ existingClass: DayTimetable) {
        let weekDay = Calendar.current.component(.weekday, from: changeClass.afterDate)

        switch weekDay {
        case 2:
            timetable.monday.append(DayTimetable(period1: changeClass.period1, period2: changeClass.period2, classData: existingClass.classData))
        case 3:
            timetable.tuesday.append(DayTimetable(period1: changeClass.period1, period2: changeClass.period2, classData: existingClass.classData))
        case 4:
            timetable.wednesday.append(DayTimetable(period1: changeClass.period1, period2: changeClass.period2, classData: existingClass.classData))
        case 5:
            timetable.thursday.append(DayTimetable(period1: changeClass.period1, period2: changeClass.period2, classData: existingClass.classData))
        case 6:
            timetable.friday.append(DayTimetable(period1: changeClass.period1, period2: changeClass.period2, classData: existingClass.classData))
        default:
            break
        }
    }
}

extension TimetableViewModel {
    enum Navigation {
        case classDetail(Class, ClassChange?)
    }
}

private extension Date {
    func getMondayOfWeek() -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        let daysToAddToMonday = 2 - weekday
        
        return calendar.date(byAdding: .day, value: daysToAddToMonday, to: self)!
    }
    func getFridayOfWeek() -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        let daysToAddToMonday = 6 - weekday
        
        return calendar.date(byAdding: .day, value: daysToAddToMonday, to: self)!
    }
}
