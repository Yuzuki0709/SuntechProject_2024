//
//  AttendanceStatusViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/12.
//

import SwiftUI
import Foundation
import Combine

final class AttendanceStatusViewModel: ObservableObject {
    @Published private var realmManager: AttendanceRealmManager = .shared
    @Published private(set) var attendanceCount: Int = 0
    @Published private(set) var absenceCount: Int = 0
    @Published private(set) var latenessCount: Int = 0
    @Published private(set) var officialAbsenceCount: Int = 0
    @Published private(set) var attendanceLogs: [AttendanceLog] = []
    
    @Published var isStatusButtonTapped: (Bool, AttendanceStatus?) = (false, nil) {
        didSet {
            if isStatusButtonTapped.0 { // ボタンが押されたら2秒後に押下状態を解除する
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.isStatusButtonTapped = (false, nil)
                }
            }
        }
    }
    
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
                self?.attendanceLogs = Array(classAttendance.logs).sorted(by: { $0.date > $1.date })
            })
            .store(in: &cancellables)
    }
    
    func isExistClass() -> Bool {
        return realmManager.isExisting(classId: classData.id)
    }
    
    func addClassAttendance() {
        realmManager.addClassAttendance(classId: classData.id)
    }
    
    func addAttendanceLog(status: AttendanceStatus) {
        realmManager.addAttendanceLog(classId: classData.id, status: status, date: Date())
    }
    
    func deleteAttendanceLog(log: AttendanceLog) {
        realmManager.deleteAttendanceLog(log)
    }
}

