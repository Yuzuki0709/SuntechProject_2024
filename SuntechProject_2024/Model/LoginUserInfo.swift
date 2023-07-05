//
//  LoginUserInfo.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/04.
//

import Foundation

final class LoginUserInfo {
    static let shared = LoginUserInfo()
    
    private var _currentUser: LoginUser?
    var currentUser: LoginUser? {
        _currentUser
    }
    
    private init() {}
    
    func setUserInfo(_ user: LoginUser) {
        self._currentUser = user
    }
}
