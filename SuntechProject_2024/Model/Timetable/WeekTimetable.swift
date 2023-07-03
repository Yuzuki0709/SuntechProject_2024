//
//  WeekTimetable.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

struct WeekTimetable: Identifiable, Codable {
    let id: UUID = UUID()
    let monday: [DayTimetable]
    let tuesday: [DayTimetable]
    let wednesday: [DayTimetable]
    let thursday: [DayTimetable]
    let friday: [DayTimetable]
    
    enum CodingKeys: String, CodingKey {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
    }
}
