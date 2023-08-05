//
//  AddChatroomViewModel.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/01.
//

import Foundation
import Combine

final class AddChatroomViewModel: ObservableObject {
    @Published var chatUsers: [ChatUser] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedUser: ChatUser? = nil
    @Published var apiError: SuntechAPIError? = nil
    
    var searchResults: [ChatUser] {
        return chatUsers.filter { $0.name.contains(searchText) }
    }
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
    }
    
    func fetchAllChatUser() {
        isLoading = true
        guard let id = LoginUserInfo.shared.currentUser?.user.id else { return }
        suntechAPIClient.fetchAllChatUser { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let chatUsers):
                self.chatUsers = chatUsers.filter { $0.id != id }
            case .failure(let error):
                print(error)
            }
            
            self.isLoading = false
        }
    }
    
    func sendChatroom() {
        guard let userId1 = LoginUserInfo.shared.currentUser?.user.id else { return }
        guard let userId2 = selectedUser?.id else { return }
        
        isLoading = true
        suntechAPIClient.sendChatroom(
            userId1: userId1,
            userId2: userId2,
            roomName: "テスト部屋"
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success():
                // TODO: チャット画面へ遷移する
                print("Success!")
            case .failure(let error):
                self.apiError = error
            }
            
            self.isLoading = false
        }
        
        selectedUser = nil
    }
}
