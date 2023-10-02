//
//  LoginState.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/10/01.
//

import Foundation

enum LoginState: Equatable {
    case initial
    case loading
    case success
    case wait
    case error
}
