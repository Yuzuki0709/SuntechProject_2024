//
//  AttendanceLog.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import Foundation
import RealmSwift

final class AttendanceLog: Object, Identifiable {
    @Persisted var id: String = UUID().uuidString
    @Persisted var date: Date
    @Persisted var status: AttendanceStatus
}
