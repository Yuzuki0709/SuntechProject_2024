//
//  WeekTimetable.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

public struct WeekTimetable: Identifiable, Codable {
    public let id: UUID = UUID()
    public let monday: [DayTimetable]
    public let tuesday: [DayTimetable]
    public let wednesday: [DayTimetable]
    public let thursday: [DayTimetable]
    public let friday: [DayTimetable]
    
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
                            emailAddress: "sugita@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60,
                        classroomUrl: nil)),
        
        DayTimetable(period1: 3,
                     period2: 4,
                     classData: Class(
                        id: "23C4111-0237",
                        name: "デザインパターン",
                        teacher: Teacher(
                            id: "F-0007",
                            name: "保坂　修治",
                            emailAddress: "hosaka@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60,
                        classroomUrl: "https://classroom.google.com/u/0/c/NTk1ODg0MzM1NDky"))
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
                            emailAddress: "yoshi@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60,
                        classroomUrl: "https://classroom.google.com/u/0/c/NjAyODI5ODcxMjQ4?"))
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
                            emailAddress: "fuka@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60,
                        classroomUrl: nil))
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
                            emailAddress: "yamaki@suntech.jp"),
                        creditsCount: 4,
                        timeCount: 60,
                        classroomUrl: "https://classroom.google.com/u/0/c/NjAzOTI5MTE1NzQ3"))
    ],
    friday: []
)

#endif

