//
//  ChatMessageView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/06.
//

import SwiftUI

struct ChatMessageView: View {
    @ObservedObject var viewModel: ChatMessageViewModel
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                viewModel.fetchChatMessage()
            }
    }
    
    init(viewModel: ChatMessageViewModel) {
        self.viewModel = viewModel
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(
            viewModel: ChatMessageViewModel(
                chatroom: Chatroom(
                    id: 1,
                    name: "サンプル部屋",
                    createdAt: Date(),
                    updateAt: Date(),
                    partner: ChatUser(
                        id: "F-0001",
                        name: "秋山　康平",
                        iconImageUrl: nil
                    )
                )
            )
        )
    }
}
