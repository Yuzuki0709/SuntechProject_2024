//
//  AttendanceLog.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import Foundation
import RealmSwift

final class AttendanceLog: Object {
    @Persisted var date: Date
    @Persisted var status: AttendanceStatus
}
