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
    
    private let chatroom: Chatroom
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(chatroom: Chatroom, suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.chatroom = chatroom
        self.suntechAPIClient = suntechAPIClient
    }
    
    func fetchChatMessage() {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        suntechAPIClient.fetchChatMessage(userId: userId, roomId: chatroom.id) { result in
            switch result {
            case .success(let messages):
                print(messages)
            case .failure(let error):
                print(error)
            }
        }
    }
}
