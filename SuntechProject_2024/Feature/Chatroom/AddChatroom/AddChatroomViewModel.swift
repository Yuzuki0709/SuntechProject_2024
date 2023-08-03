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
    var searchResults: [ChatUser] {
        return chatUsers.filter { $0.name.contains(searchText) }
    }
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
    }
    
    func fetchAllChatUser() {
        isLoading = true
        suntechAPIClient.fetchAllChatUser { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let chatUsers):
                self.chatUsers = chatUsers
            case .failure(let error):
                print(error)
            }
            
            self.isLoading = false
        }
    }
}
