//
//  DateHelper.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/12.
//

import Foundation

final class DateHelper {
    private static var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        
        return formatter
    }
}
