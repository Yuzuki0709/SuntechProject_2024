//
//  LoginViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation
import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var isLoading: Bool = false
    @Published var loginUser: LoginUser? = nil
    @Published var error: Error? = nil
    @Published var isLock: Bool = false
    @Published var lockoutDurationDiffMinuteNow: Int = 0
    
    private let _navigationSubject = PassthroughSubject<Navigation, Never>()
    
    private var failureCount: Int = 0
    private var lockoutDuration: Date? {
        didSet {
            if let lockoutDuration = lockoutDuration {
                isLock = lockoutDuration > Date()
                if isLock {
                    scheduleUnlockTimer(for: lockoutDuration)
                    startUpdateLockoutDurationTimer()
                }
            } else {
                isLock = false
                cancelUnlockTimer()
            }
        }
    }
    private var unlockTimer: Timer?
    private var updateLockoutDurationTimer: Timer?
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    
    var navigationSignal: AnyPublisher<Navigation, Never> {
        _navigationSubject.eraseToAnyPublisher()
    }
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
    }
    
    deinit {
        stopUpdateLockoutDurationTimer()
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
                // ログインに成功したら画面遷移する
                _navigationSubject.send(.main)
            case .failure(let error):
                self.error = error as Error
                self.failureCount += 1
                self.handleLoginFailure()
            }
            self.isLoading = false
        }
    }
    
    private func handleLoginFailure() {
        switch failureCount {
        case 4:
            lockoutDuration = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
        case 5:
            lockoutDuration = Calendar.current.date(byAdding: .minute, value: 10, to: Date())
        case 6:
            lockoutDuration = Calendar.current.date(byAdding: .minute, value: 30, to: Date())
        case (7...):
            lockoutDuration = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        default:
            lockoutDuration = nil
        }
    }
    
    private func scheduleUnlockTimer(for unlockTime: Date) {
        cancelUnlockTimer()
        let timer = Timer(fire: unlockTime, interval: 0, repeats: false) { [weak self] _ in
            self?.unlockTimerFired()
            self?.stopUpdateLockoutDurationTimer()
        }
        RunLoop.main.add(timer, forMode: .common)
        unlockTimer = timer
    }
    
    private func cancelUnlockTimer() {
        unlockTimer?.invalidate()
        unlockTimer = nil
    }
    
    private func unlockTimerFired() {
        lockoutDuration = nil
    }
    
    private func startUpdateLockoutDurationTimer() {
        updateLockoutDurationDiffMinuteNow()
        updateLockoutDurationTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.updateLockoutDurationDiffMinuteNow()
        }
    }
    
    private func stopUpdateLockoutDurationTimer() {
        updateLockoutDurationTimer?.invalidate()
        updateLockoutDurationTimer = nil
    }
    
    private func updateLockoutDurationDiffMinuteNow() {
        guard let lockoutDuration = lockoutDuration else {
            lockoutDurationDiffMinuteNow = 0
            return
        }
        let diffMinute = Calendar.current.dateComponents([.minute], from: Date(), to: lockoutDuration).minute ?? 0
        lockoutDurationDiffMinuteNow = max(0, diffMinute)
    }
}

extension LoginViewModel {
    enum Navigation {
        case main
    }
}
