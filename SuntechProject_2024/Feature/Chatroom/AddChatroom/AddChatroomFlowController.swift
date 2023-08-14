//
//  AddChatroomFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/01.
//

import Foundation
import Combine

final class AddChatroomFlowController: HostingController<AddChatroomView>, AddChatroomFlowControllerService {
    
    private var cancellable = Set<AnyCancellable>()
    
    private var viewModel: AddChatroomViewModel {
        host.rootView.viewModel
    }
    
    override init(rootView: AddChatroomView) {
        super.init(rootView: rootView)
    }
    
    func start() {
        cancellable = Set()
        
        viewModel.navigationSignal
            .sink(receiveValue: { [weak self] navigation in
                guard let self else { return }
                switch navigation {
                case .chatMessage(let chatroom):
                    self.startChatMessage(chatroom)
                }
            })
            .store(in: &cancellable)
    }
    
    private func startChatMessage(_ chatroom: Chatroom) {
        let chatMessage = NavigationContainer.shared.chatMessageFlowController(chatroom)
        chatMessage.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatMessage, animated: true)
        chatMessage.start()
    }
}
