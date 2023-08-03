//
//  ChatUser.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/23.
//

import Foundation

public struct ChatUser: Codable, Identifiable {
    public let id: String
    public let name: String
    public let iconImageUrl: String?
    
    var type: Self.UserType {
        switch id.first {
        case "F", "P":
            return .teacher
        case "C":
            return .student(.C)
        case "M":
            return .student(.M)
        case "S":
            return .student(.S)
            
        default:
            return .unknownd
        }
    }
    
    
    enum UserType: Equatable {
        case teacher
        case student(Department)
        case unknownd
    }
}
