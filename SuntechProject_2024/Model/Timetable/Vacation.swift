//
//  Vacation.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/09/13.
//

import Foundation

public struct Vacation: Codable, Identifiable {
    public let id: UInt64
    public let name: String
    public let startDate: Date
    public let endDate: Date
}
