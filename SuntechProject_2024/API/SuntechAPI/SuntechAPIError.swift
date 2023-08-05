//
//  SuntechAPIError.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/05.
//

import Foundation

public enum SuntechAPIError: Error {
    case invalidURL
    case networkError
    case existingChatroom
    case unknown
    
    var description: String{
        switch self{
        case .invalidURL:
            return "別の検索ワードを試してください。検索ワードには半角英数字のみお使いいただけます。"
        case .networkError:
            return "接続環境の良いところでもう一度お試しください。"
        case .existingChatroom:
            return "このユーザーらのチャットは既に存在します。"
        case .unknown:
            return "不明なエラーです。"
        }
    }
}
