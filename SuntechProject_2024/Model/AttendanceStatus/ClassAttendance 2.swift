//
//  ClassAttendance.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import Foundation
import RealmSwift

final class ClassAttendance: Object, ObjectKeyIdentifiable {
    @Persisted var classId: String
    @Persisted var logs: List<AttendanceLog> = List<AttendanceLog>()
    
    var attendanceCount: Int {
        return logs.filter { $0.status == .attendance }.count
    }
    
    var absenceCount: Int {
        return logs.filter { $0.status == .absence }.count
    }
    
    var latenessCount: Int {        
        return logs.filter { $0.status == .lateness }.count
    }
    
    var officialAbsenceCount: Int {
        return logs.filter { $0.status == .officialAbsence }.count
    }
}
