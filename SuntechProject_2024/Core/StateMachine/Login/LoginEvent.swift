//
//  LoginEvent.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/10/01.
//

import Foundation

enum LoginEvent {
    case onAppear
    case login
    case didFetchResultSuccessfully(_ result: LoginUser)
    case didFetchResultFailure(_ error: Error)
}
