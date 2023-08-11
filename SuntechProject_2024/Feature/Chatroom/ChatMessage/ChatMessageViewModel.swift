//
//  ChatMessageViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/06.
//

import Foundation
import Combine

final class ChatMessageViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText: String = ""
    @Published var isFocused: Bool = false
    
    private let chatroom: Chatroom
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(chatroom: Chatroom, suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.chatroom = chatroom
        self.suntechAPIClient = suntechAPIClient
    }
    
    func fetchChatMessage() {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        suntechAPIClient.fetchChatMessage(userId: userId, roomId: chatroom.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages
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
