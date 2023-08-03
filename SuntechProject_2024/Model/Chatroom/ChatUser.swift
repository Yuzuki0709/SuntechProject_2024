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
}
