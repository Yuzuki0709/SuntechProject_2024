//
//  LoginViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation
import SwiftUI
import Combine

final class LoginViewModel: StateMachine<LoginState, LoginEvent> {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var lockoutDurationDiffMinuteNow: Int = 0
    
    private let _navigationSubject = PassthroughSubject<Navigation, Never>()
    
    private var failureCount: Int = 0
    private var lockoutDuration: Date? {
        didSet {
            if let lockoutDuration = lockoutDuration {
                if lockoutDuration > Date() {
                    send(event: .lock)
                }
            } else {
                if state == .wait {
                    send(event: .unlock)
                }
            }
        }
    }
    private var unlockTimer: Timer?
    private var updateLockoutDurationTimer: Timer?
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    
    var navigationSignal: AnyPublisher<Navigation, Never> {
        _navigationSubject.eraseToAnyPublisher()
    }
    
    init(
        initialState: LoginState = .initial,
        suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()
    ) {
        self.suntechAPIClient = suntechAPIClient
        super.init(initialState)
    }
    
    deinit {
        stopUpdateLockoutDurationTimer()
    }
    
    override func handleStateUpdate(_ oldState: LoginState, new newState: LoginState) {
        switch(oldState, newState) {
        case (.initial, .loading):
            break
        case (.loading, .success):
            failureCount = 0
            _navigationSubject.send(.main)
            
        case (.loading, .error):
            failureCount += 1
            handleLoginFailure()
            
        case (_, .wait):
            scheduleUnlockTimer(for: lockoutDuration)
            startUpdateLockoutDurationTimer()
            
        case (_, .initial):
            break
            
        default:
            fatalError("You lended in a misterious place... Coming from \(oldState) and trying to get to \(newState)")
        }
    }
    
    override func handleEvent(_ event: LoginEvent) -> LoginState? {
        switch(state, event) {
        case (.initial, .login):
            login()
            return .loading
            
        case (.loading, .didFetchResultSuccessfully(let loginUser)):
            LoginUserInfo.shared.setUserInfo(loginUser, password: passwordText)
            return .success
            
        case (.loading, .didFetchResultFailure(let error)):
            self.error = error
            return .error
            
        case (_, .lock):
            return .wait
            
        case (.wait, .unlock):
            cancelUnlockTimer()
            return .initial
            
        case (.error, .alertPositiveButtonTap):
            self.error = nil
            return .initial
            
        case (.wait, .alertPositiveButtonTap):
            break
            
        default:
            fatalError("Event not handled...")
        }
        return nil
    }
    
    func login() {
        suntechAPIClient.login(email: emailText, password: passwordText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loginUser):
                self.send(event: .didFetchResultSuccessfully(loginUser))
            case .failure(let error):
                self.send(event: .didFetchResultFailure(error))
            }
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
    
    private func scheduleUnlockTimer(for unlockTime: Date?) {
        guard let unlockTime else { return }
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
