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
    @Published private(set) var isLoading: Bool = false
    @Published var today: Date?
    @Published var monday: Date?
    @Published var friday: Date?
    
    private var cancellables = Set<AnyCancellable>()
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    private let _navigationSubject = PassthroughSubject<Navigation, Never>()
    var navigationSignal: AnyPublisher<Navigation, Never> {
        _navigationSubject.eraseToAnyPublisher()
    }
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
        self.fetchVacations()
    }
    
    func fetchWeekTimetable() {
        guard let currentUser = LoginUserInfo.shared.currentUser,
              let password = LoginUserInfo.shared.password,
              let student = currentUser.user as? Student else { return }
        
        isLoading = true
        
        suntechAPIClient.fetchWeekTimetable(studentId: student.id, password: password) { [weak self] result in
            switch result {
            case .success(let weekTimetable):
                self?.weekTimetable = weekTimetable
            case .failure(let error):
                print(error)
            }
            
            self?.isLoading = false
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
