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
    @Published private(set) var isLoading: Bool = false
    @Published var today: Date?
    @Published var monday: Date?
    @Published var friday: Date?
    @Published var month: Int = Calendar.current.component(.month, from: .now)
    
    private var cancellables = Set<AnyCancellable>()
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    private let _navigationSubject = PassthroughSubject<Navigation, Never>()
    var navigationSignal: AnyPublisher<Navigation, Never> {
        _navigationSubject.eraseToAnyPublisher()
    }
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
        self.fetchVacations()
        
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
                guard let self,
                      let today = self.today else {
                    return
                }
                
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
    
    func navigate(_ navigation: Navigation) {
        _navigationSubject.send(navigation)
    }
}

extension TimetableViewModel {
    enum Navigation {
        case classDetail(Class)
    }
}
