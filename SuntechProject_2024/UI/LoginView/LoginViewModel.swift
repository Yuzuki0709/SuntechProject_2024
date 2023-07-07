//
//  LoginViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var isLoading: Bool = false
    @Published var loginUser: LoginUser? = nil
    @Published var error: Error? = nil
    
    private var failureCount: Int = 0
    private var lockoutDuration: Date?
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
    }
    
    func login() {
        isLoading = true
        suntechAPIClient.login(email: emailText, password: passwordText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loginUser):
                self.loginUser = loginUser
                self.failureCount = 0
                LoginUserInfo.shared.setUserInfo(loginUser, password: self.passwordText)
            case .failure(let error):
                self.error = error as Error
                self.failureCount += 1
            }
            self.isLoading = false
        }
    }
}
