//
//  DomainError.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/10/02.
//

import Foundation

public enum DomainError: Error {
    case network
    case loginFailure
    
    var message: String {
        switch self {
        case .network:
            return "ネットワーク接続エラー"
        case .loginFailure:
            return "ログイン失敗"
        }
    }
    
    var description: String {
        switch self {
        case .network:
            return "接続環境を見直して、やり直してください"
        case .loginFailure:
            return "メールアドレスまたはパスワードを再入力してください。"
        }
    }
}
