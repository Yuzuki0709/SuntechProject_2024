//
//  ClassChange.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/11/16.
//

import Foundation

public struct ClassChange: Identifiable, Codable {
    public let id: Int
    public let classId: String
    public let beforeDate: Date
    public let afterDate: Date
}
