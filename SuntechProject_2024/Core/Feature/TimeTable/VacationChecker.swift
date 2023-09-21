//
//  VacationChecker.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/09/16.
//

import Foundation

final class VacationChecker {
    static func isVacationInToday(
        _ today: Date,
        vacation: Vacation
    ) -> Bool {
        return vacation.startDate <= today && today <= vacation.endDate
    }
    
    static func isVacationInWeek(
        today: Date,
        monday: Date,
        friday: Date,
        vacation: Vacation
    ) -> Bool {
        if self.isDayInSpecifiedWeek(today, monday: monday, friday: friday) {
            return isVacationInToday(today, vacation: vacation)
        } else {
            return vacation.startDate <= monday && friday <= vacation.endDate
        }
    }
    
    private static func isDayInSpecifiedWeek(
        _ day: Date,
        monday: Date,
        friday: Date
    ) -> Bool {
        return monday <= day && day <= friday
    }
}
