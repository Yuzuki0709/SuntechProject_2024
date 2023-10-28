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
    @Published private(set) var weekTimetable: WeekTimetable?
    @Published private(set) var vacations: [Vacation] = []
    @Published private(set) var vacation: Vacation? = nil
    @Published private(set) var cancellClasses: [ClassCancellation] = []
    @Published var cancellClassesInWeek: [ClassCancellation] = []
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
    
    func navigate(_ navigation: Navigation) {
        _navigationSubject.send(navigation)
    }
}

extension TimetableViewModel {
    enum Navigation {
        case classDetail(Class)
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
