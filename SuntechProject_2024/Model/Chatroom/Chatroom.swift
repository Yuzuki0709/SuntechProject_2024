//
//  Chatroom.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/23.
//

import Foundation

public struct Chatroom: Codable, Identifiable {
    public let id: Int64
    public let name: String
    public let createdAt: Date
    public let updateAt: Date
    public let partner: ChatUser
}
