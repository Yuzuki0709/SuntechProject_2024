//
//  ChatMessageViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/06.
//

import Foundation
import Combine

final class ChatMessageViewModel: ObservableObject {
    @Published var messageOfDay: [ChatMessageOfDay] = []
    @Published var messageText: String = ""
    @Published var isFocused: Bool = false
    
    let chatroom: Chatroom
    private let suntechAPIClient: SuntechAPIClientProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(chatroom: Chatroom, suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.chatroom = chatroom
        self.suntechAPIClient = suntechAPIClient
        self.fetchChatMessage()
    }
    
    func startFetchChatMessageTimer() {
        Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchChatMessage()
            }
            .store(in: &cancellables)
    }
    
    func stopFetchChatMessageTimer() {
        cancellables.map { $0.cancel() }
    }
    
    func fetchChatMessage() {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        suntechAPIClient.fetchChatMessage(userId: userId, roomId: chatroom.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let messages):
                self.messageOfDay = messages
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendChatMessage() {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        suntechAPIClient.sendChatMessage(userId: userId, roomId: chatroom.id, text: messageText) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                self.fetchChatMessage()
            case .failure(let error):
                print(error)
            }
        }
    }
}
