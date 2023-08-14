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
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        messages()
                    }
                }
                .onChange(of: viewModel.messageOfDay) { _ in
                    scrollToBottomWithAnimation(proxy: proxy, anchor: .top)
                }
                .onChange(of: viewModel.isFocused) { newValue in
                    if newValue {
                        scrollToBottomWithAnimation(proxy: proxy, anchor: .top)
                    }
                }
            }
            MessageTextField(viewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchChatMessage()
        }
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .backgroundColor(color: Color(R.color.common.backgroundColor))
        .navigationTitle("メッセージ")
    }
    
    init(viewModel: ChatMessageViewModel) {
        self.viewModel = viewModel
    }
    
    private func messages() -> some View {
        VStack(spacing: 0) {
            ForEach(viewModel.messageOfDay) { messageOfDay in
                DateHeader(
                    title: DateHelper.formatToString(
                        date: messageOfDay.dateTime,
                        format: "yyyy年MM月dd日"
                    )
                )
                ForEach(messageOfDay.messages) { message in
                    messageView(message)
                        .padding(.vertical, .app.space.spacingXS)
                        .id(message.id)
                }
            }
        }
    }
    
    @ViewBuilder
    private func messageView(_ message: ChatMessage) -> some View {
        if message.user.id == LoginUserInfo.shared.currentUser?.user.id {
            MyCommentView(
                date: DateHelper.formatToString(
                    date: message.sendAt,
                    format: "HH:mm"
                )
            ) {
                Text(message.text)
            }
        } else {
            CommentView(
                date: DateHelper.formatToString(
                    date: message.sendAt,
                    format: "HH:mm"
                )
            ) {
                Text(message.text)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, anchor: UnitPoint) {
        guard let messageOfDay = viewModel.messageOfDay.last,
              let message = messageOfDay.messages.last else { return }
        proxy.scrollTo(message.id, anchor: anchor)
    }
    
    private func scrollToBottomWithAnimation(proxy: ScrollViewProxy, anchor: UnitPoint) {
        withAnimation {
            scrollToBottom(proxy: proxy, anchor: anchor)
        }
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
                    recentMessage: "これはサンプルです。",
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
