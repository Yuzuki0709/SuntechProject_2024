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

#if DEBUG

let sampleWeekTimetable = WeekTimetable(
    monday: [
        DayTimetable(period1: 2,
                     period2: 0,
                     classData: Class(
                        id: "23C4110-0238",
                        name: "量子コンピューティング",
                        teacher: Teacher(
                            id: "F-0004",
                            name: "杉田 勝実",
                            password: "password",
                            emailAddress: "sugita@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60)),
        
        DayTimetable(period1: 3,
                     period2: 4,
                     classData: Class(
                        id: "23C4111-0237",
                        name: "デザインパターン",
                        teacher: Teacher(
                            id: "F-0007",
                            name: "保坂　修治",
                            password: "password",
                            emailAddress: "hosaka@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60))
    ],
    tuesday: [
        DayTimetable(period1: 1,
                     period2: 2,
                     classData: Class(
                        id: "23C4111-0240",
                        name: "ネットワーク演習Ⅰ",
                        teacher: Teacher(
                            id: "F-0008",
                            name: "山本　芳彦",
                            password: "password",
                            emailAddress: "yoshi@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60))
    ],
    wednesday: [
        DayTimetable(period1: 1,
                     period2: 2,
                     classData: Class(
                        id: "23C4101-0234",
                        name: "暗号理論",
                        teacher: Teacher(
                            id: "F-0006",
                            name: "深澤　克朗",
                            password: "password",
                            emailAddress: "fuka@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60))
    ],
    thursday: [
        DayTimetable(period1: 3,
                     period2: 4,
                     classData: Class(
                        id: "23C4101-0232",
                        name: "データベース演習Ⅰ",
                        teacher: Teacher(
                            id: "P-0024",
                            name: "八巻　栄家",
                            password: "password",
                            emailAddress: "yamaki@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60))
    ],
    friday: []
)

#endif

