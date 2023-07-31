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
    
    private let suntechAPIClient: SuntechAPIClientProtocol
    
    init(suntechAPIClient: SuntechAPIClientProtocol = SuntechAPIClient()) {
        self.suntechAPIClient = suntechAPIClient
    }
    
}
