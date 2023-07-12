//
//  AttendanceStatusViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/12.
//

import SwiftUI
import Foundation

final class AttendanceStatusViewModel: ObservableObject {
    private let classData: Class
    private let realmManager: AttendanceRealmManager
    
    var attendanceCount: Int {
        guard let classAttendance = realmManager.getClassAttendance(classId: classData.id) else { return 0 }
        return classAttendance.logs.filter { $0.status == .attendance }.count
    }
    
    var absenceCount: Int {
        guard let classAttendance = realmManager.getClassAttendance(classId: classData.id) else { return 0 }
        
        return classAttendance.logs.filter { $0.status == .absence }.count
    }
    
    var latenessCount: Int {
        guard let classAttendance = realmManager.getClassAttendance(classId: classData.id) else { return 0 }
        
        return classAttendance.logs.filter { $0.status == .lateness }.count
    }
    
    init(classData: Class, realmManager: AttendanceRealmManager = AttendanceRealmManager()) {
        self.classData = classData
        self.realmManager = realmManager
    }
    
    func addAttendanceLog(status: AttendanceStatus) {
        realmManager.addAttendanceLog(classId: classData.id, status: status, date: Date())
    }
}

