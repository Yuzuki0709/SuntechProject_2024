//
//  ClassDetailViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/18.
//

import Foundation
import Combine

final class ClassDetailViewModel: ObservableObject {
    @Published private var realmManager: AttendanceRealmManager = .init()
    @Published private(set) var attendanceCount: Int = 0
    @Published private(set) var absenceCount: Int = 0
    @Published private(set) var latenessCount: Int = 0
    @Published private(set) var officialAbsenceCount: Int = 0
    
    private var classData: Class
    private var cancellables = Set<AnyCancellable>()
    
    init(classData: Class) {
        self.classData = classData
        
        realmManager.$classAttendances
            .compactMap { [unowned self] _ in self.realmManager.getClassAttendance(classId: self.classData.id) }
            .sink(receiveValue: { [weak self] classAttendance in
                self?.attendanceCount = classAttendance.attendanceCount
                self?.absenceCount = classAttendance.absenceCount
                self?.latenessCount = classAttendance.latenessCount
                self?.officialAbsenceCount = classAttendance.officialAbsenceCount
            })
            .store(in: &cancellables)
    }
    
    func isExistClass() -> Bool {
        return realmManager.isExisting(classId: classData.id)
    }
}
