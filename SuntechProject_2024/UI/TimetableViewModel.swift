//
//  TimetableViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/05.
//

import Foundation
import SwiftUI

final class TimetableViewModel: ObservableObject {
    @Published private(set) var weekTimetable: WeekTimetable?
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
    }
    
    func fetchWeekTimetable() {
        guard let currentUser = LoginUserInfo.shared.currentUser else { return }
        guard let student = currentUser.user as? Student else { return }
        suntechAPIClient.fetchWeekTimetable(studentId: student.id, password: student.password) { [weak self] result in
            switch result {
            case .success(let weekTimetable):
                self?.weekTimetable = weekTimetable
            case .failure(let error):
                print(error)
            }
        }
    }
}
