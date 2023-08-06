//
//  ChatroomTopFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import Foundation
import Combine

final class ChatroomTopFlowController: HostingController<ChatroomTopView>, ChatroomFlowControllerService {
    
    private var cancellable = Set<AnyCancellable>()
    
    private var viewModel: ChatroomTopViewModel {
        host.rootView.viewModel
    }
    
    override init(rootView: ChatroomTopView) {
        super.init(rootView: rootView)
    }
    
    func start() {
        
        cancellable = Set()
        
        viewModel.navigationSignal
            .sink(receiveValue: { [weak self] navigation in
                guard let self else { return }
                switch navigation {
                case .addChatroom:
                    startAddChatroom()
                    
                case .chatMessage:
                    startChatMessage()
                }
            })
            .store(in: &cancellable)
    }
    
    private func startAddChatroom() {
        let addChatroom = NavigationContainer.shared.addChatroomFlowController()
        navigationController?.pushViewController(addChatroom, animated: true)
        addChatroom.start()
    }
    
    private func startChatMessage() {
        let chatMessage = NavigationContainer.shared.chatMessageFlowController()
        navigationController?.pushViewController(chatMessage, animated: true)
        chatMessage.start()
    }
}
