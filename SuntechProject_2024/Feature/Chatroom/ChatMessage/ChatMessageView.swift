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
        List {
            ForEach(viewModel.messages) { message in
                if message.user.id == LoginUserInfo.shared.currentUser?.user.id {
                    MyCommentView(
                        date: DateHelper.formatToString(
                            date: message.sendAt,
                            format: "yyyy-MM-dd"
                        )
                    ) {
                        Text(message.text)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                } else {
                    CommentView(
                        date: DateHelper.formatToString(
                            date: message.sendAt,
                            format: "yyyy-MM-dd"
                        )
                    ) {
                        Text(message.text)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.fetchChatMessage()
        }
        .backgroundColor(color: Color(R.color.common.backgroundColor))
        .navigationTitle("メッセージ")
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
