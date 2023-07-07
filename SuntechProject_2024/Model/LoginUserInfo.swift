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
    private var _password: String?
    var currentUser: LoginUser? {
        _currentUser
    }
    var password: String? {
        _password
    }
    
    private init() {}
    
    func setUserInfo(_ user: LoginUser, password: String) {
        self._currentUser = user
        self._password = password
    }
}
