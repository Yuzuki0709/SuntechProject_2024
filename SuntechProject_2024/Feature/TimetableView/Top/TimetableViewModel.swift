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
//    @Published private(set) var weekTimetable = WeekTimetable(monday: [], tuesday: [], wednesday: [], thursday: [], friday: [])
    @Published var weekTimetable: WeekTimetable? = nil
    @Published private(set) var vacations: [Vacation] = []
    @Published private(set) var vacation: Vacation? = nil
    @Published private(set) var cancellClasses: [ClassCancellation] = []
    @Published var cancellClassesInWeek: [ClassCancellation] = []
    @Published private(set) var changeClasses: [ClassChange] = []
    @Published var changeClassesInWeek: [ClassChange] = []
    @Published var timetableInWeek: WeekTimetable? = nil
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
        
//        $timetableInWeek
//        Publishers.CombineLatest($weekTimetable, $changeClassesInWeek)
//            .map { timetable, changeClasses in
//            }
//            .assign(to: \.timetableInWeek, on: self)
//            .store(in: &cancellables)
        
        Publishers.CombineLatest($weekTimetable, $changeClassesInWeek)
            .map { timetable, changeClasses in
                // TODO: 1. タイムテーブル内に変更授業があるかどうか判別
                // TODO: 2. あるならafterDateから曜日を算出
                // TODO: 3. その曜日に授業情報を追加
                // TODO: 4. タイムテーブルから元の授業情報を削除
                // TODO: 5. リファクタリング
                
                guard let timetable = timetable else { return nil }
                var updateTimetable = timetable
                let week = timetable.monday + timetable.tuesday + timetable.wednesday + timetable.thursday + timetable.friday
                
                if let change = changeClasses.filter { a in
                    week.contains { b in
                        a.classId == b.classData.id
                    }
                }.first {
                    if let hoge = week.filter { a in
                        changeClasses.contains { b in
                            a.classData.id == b.classId
                        }
                    }.first {
                        let weekDay = Calendar.current.component(.weekday, from: change.afterDate)
                        updateTimetable.monday.removeAll(where: { $0.id == hoge.id })
                        updateTimetable.tuesday.removeAll(where: { $0.id == hoge.id })
                        updateTimetable.wednesday.removeAll(where: { $0.id == hoge.id })
                        updateTimetable.thursday.removeAll(where: { $0.id == hoge.id })
                        updateTimetable.friday.removeAll(where: { $0.id == hoge.id })
                        
                        // TODO: 日付と数字の対応の見直し
                        switch weekDay {
                        case 2:
                            updateTimetable.monday.append(DayTimetable(period1: change.period1, period2: change.period2, classData: hoge.classData))
                        case 3:
                            updateTimetable.tuesday.append(DayTimetable(period1: change.period1, period2: change.period2, classData: hoge.classData))
                        case 4:
                            updateTimetable.wednesday.append(DayTimetable(period1: change.period1, period2: change.period2, classData: hoge.classData))
                        case 5:
                            updateTimetable.thursday.append(DayTimetable(period1: change.period1, period2: change.period2, classData: hoge.classData))
                        case 6:
                            updateTimetable.friday.append(DayTimetable(period1: change.period1, period2: change.period2, classData: hoge.classData))
                        default:
                            break
                        }
                    }
                }
                return updateTimetable
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
