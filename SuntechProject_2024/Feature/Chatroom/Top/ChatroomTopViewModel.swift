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
    var searchResults: [Chatroom] {
        return chatrooms.filter { $0.partner.name.contains(searchText) }
    }
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var myAccount: ChatUser? = nil
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private let _navigationSubject = PassthroughSubject<Navigation, Never>()
    var navigationSignal: AnyPublisher<Navigation, Never> {
        _navigationSubject.eraseToAnyPublisher()
    }
    
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
                
            case .failure(let error):
                print(error)
            }
            
            self.isLoading = false
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
