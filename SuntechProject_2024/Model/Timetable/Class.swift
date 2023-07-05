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
    
    public var isRequired: Bool {
        let index = id.index(id.startIndex, offsetBy: 5) // 前から6文字目が必須かどうか
        return id[index] == "0"
    }
}
