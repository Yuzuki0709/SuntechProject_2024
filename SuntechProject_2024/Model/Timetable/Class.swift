//
//  Class.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

public struct Class: Identifiable, Codable {
    public let id: String
    public let name: String
    public let teacher: Teacher
    public let creditsCount: Int
    public let timeCount: Int
}
