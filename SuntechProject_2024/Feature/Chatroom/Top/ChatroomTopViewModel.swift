//
//  ChatroomTopViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/31.
//

import Foundation
import Combine

final class ChatroomTopViewModel: ObservableObject {
    @Published var chatrooms: [Chatroom] = []
    @Published var isLoading: Bool = false
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
    }
    
    func fetchChatroomList() {
        guard let userId = LoginUserInfo.shared.currentUser?.user.id else { return }
        
        isLoading = true
        
        suntechAPIClient.fetchChatroomList(userId: userId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let chatrooms):
                self.chatrooms = chatrooms
                print(chatrooms)
                
            case .failure(let error):
                print(error)
            }
            
            self.isLoading = false
        }
    }
}
