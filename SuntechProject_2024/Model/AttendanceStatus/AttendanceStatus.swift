//
//  AttendanceStatus.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import Foundation
import RealmSwift

enum AttendanceStatus: String {
    case attendance = "出席"
    case absence = "欠席"
    case lateness = "遅刻"
}

extension AttendanceStatus: CaseIterable {}
extension AttendanceStatus: PersistableEnum {}
