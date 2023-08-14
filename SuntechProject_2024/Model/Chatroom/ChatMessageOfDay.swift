//
//  ChatMessageOfDay.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/14.
//

import Foundation

/// 日付単位のチャットメッセージ一覧
struct ChatMessageOfDay: Identifiable {
    let id: UUID = UUID()
    let dateTime: Date // メッセージ送信日
    let messages: [ChatMessage]
}
