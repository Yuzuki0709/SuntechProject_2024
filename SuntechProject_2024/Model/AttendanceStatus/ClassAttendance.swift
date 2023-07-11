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
}
