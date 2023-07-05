//
//  DayTimetable.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

public struct DayTimetable: Identifiable, Codable {
    public let id: UUID = UUID()
    public let period1: Int
    public let period2: Int?
    public let classData: Class
    
    enum CodingKeys: String, CodingKey {
        case period1, period2
        case classData = "class"
    }
}
