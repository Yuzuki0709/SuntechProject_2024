//
//  DayTimetable.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

struct DayTimetable: Identifiable, Codable {
    let id: UUID = UUID()
    let period1: Int
    let period2: Int?
    let classData: Class
    
    enum CodingKeys: String, CodingKey {
        case period1, period2
        case classData = "class"
    }
}
