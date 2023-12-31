//
//  ChatroomContainerFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import Foundation

final class ChatroomContainerFlowController: NavigationController, ChatroomFlowControllerService {
    func start() {
        startTop()
    }
    
    private func startTop() {
        let top = NavigationContainer.shared.chatroomTopFlowController()
        setViewControllers([top], animated: true)
        top.start()
    }
}
