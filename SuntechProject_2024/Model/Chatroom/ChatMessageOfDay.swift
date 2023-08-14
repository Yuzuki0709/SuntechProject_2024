//
//  ChatMessageOfDay.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/14.
//

import Foundation

/// 日付単位のチャットメッセージ一覧
public struct ChatMessageOfDay: Identifiable, Equatable {
    public let id: UUID = UUID()
    public let dateTime: Date // メッセージ送信日
    public let messages: [ChatMessage]
}
