//
//  ChatMessage.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/23.
//

import Foundation


public struct ChatMessage: Codable {
    public let id: Int64
    public let text: String
    public let sendAt: Date
    public let user: ChatUser
}
