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
        let index = id.index(id.startIndex, offsetBy: 5) // 前から5文字目が必須かどうか
        return id[index] == "0"
    }
    
    public var term: Term {
        let index = id.index(id.startIndex, offsetBy: 6) // 前から6文字目が期間
        switch id[index] {
        case "0": return .allYear
        case "1": return .first
        case "2": return .second
        case "3": return .intensive
        default: return .allYear
        }
    }
}

public enum Term: String {
    case allYear = "通年"
    case first = "前期"
    case second = "後期"
    case intensive = "集中"
}
