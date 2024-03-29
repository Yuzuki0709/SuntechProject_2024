//
//  ChatroomTopViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/31.
//

import SwiftUI
import Combine
import Foundation

final class ChatroomTopViewModel: ObservableObject {
    @Published var chatrooms: [Chatroom] = []
    var searchResults: [Chatroom] {
        return chatrooms.filter { $0.partner.name.contains(searchText) }
    }
    @Published var searchText: String = ""
    @Published var myAccount: ChatUser? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    private var myTimer: Timer!
    
    private var cancellables = Set<AnyCancellable>()
    
    private let _navigationSubject = PassthroughSubject<Navigation, Never>()
    var navigationSignal: AnyPublisher<Navigation, Never> {
        _navigationSubject.eraseToAnyPublisher()
    }
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
        self.fetchChatUser()
        self.fetchChatroomList()
        // Timerを初期化し、5秒ごとにfetchChatroomListを呼び出す
        self.myTimer = Timer.scheduledTimer(
            timeInterval: 5.0, 
            target: self,
            selector: #selector(fetchChatroomListTimer),
            userInfo: nil,
            repeats: true
        )
        
        self.$selectedImage
            .compactMap { $0 }
            .sink { [weak self] selectedImage in
                self?.sendUserIcon(userIcon: selectedImage)
            }
            .store(in: &cancellables)
    }
    
    // Timerから呼び出される関数
    @objc private func fetchChatroomListTimer() {
        fetchChatroomList()
    }
    
    func fetchChatroomList() {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        suntechAPIClient.fetchChatroomList(userId: userId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let chatrooms):
                self.chatrooms = chatrooms.sorted(by: { $0.updateAt > $1.updateAt })
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchChatUser() {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        suntechAPIClient.fetchChatUser(userId: userId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.myAccount = user
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func sendUserIcon(userIcon: UIImage) {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        isLoading = true
        suntechAPIClient.sendUserIcon(userId: userId, userIcon: userIcon) { [weak self] result in
            switch result {
            case .success():
                self?.fetchChatUser()
            case .failure(let error):
                print(error)
            }
            
            self?.isLoading = false
        }
    }
    
    func navigate(_ navigation: Navigation) {
        _navigationSubject.send(navigation)
    }
}

extension ChatroomTopViewModel {
    enum Navigation {
        case addChatroom
        case chatMessage(Chatroom)
    }
}
