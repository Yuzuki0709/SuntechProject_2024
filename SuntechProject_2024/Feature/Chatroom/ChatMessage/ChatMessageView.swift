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
            
            textField
        }
        .onAppear {
            viewModel.fetchChatMessage()
        }
        .backgroundColor(color: Color(R.color.common.backgroundColor))
        .navigationTitle("メッセージ")
    }
    
    init(viewModel: ChatMessageViewModel) {
        self.viewModel = viewModel
    }
    
    //    private var textField: some View {
    //        HStack(spacing: .app.space.spacingXXS) {
    //            TextField("", text: $viewModel.messageText)
    //                .textFieldStyle(.roundedBorder)
    //                .padding(.horizontal)
    //            Button {
    //                viewModel.sendChatMessage()
    //                viewModel.messageText = ""
    //            } label: {
    //                Image(systemName: "paperplane")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .frame(width: 35, height: 20)
    //                    .padding(.app.space.spacingXS)
    //                    .foregroundColor(.white)
    //                    .background(Color(R.color.common.mainColor))
    //                    .cornerRadius(10)
    //            }
    //        }
    //        .padding(.horizontal, .app.space.spacingXS)
    //    }
    
    private var textField: some View {
        HStack(alignment: .bottom, spacing: .app.space.spacingXS) {
            AppTextEditor(
                text: $viewModel.messageText,
                isFocused: $viewModel.isFocused,
                lineLimit: .flexible(1...5),
                textContentInset: .init(
                    top: .app.space.spacingXXS,
                    leading: .app.space.spacingXXS,
                    bottom: .app.space.spacingXXS,
                    trailing: .app.space.spacingXXS
                )
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            }
            
            Button {
                viewModel.sendChatMessage()
                viewModel.messageText = ""
            } label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 20)
                    .padding(.app.space.spacingXS)
                    .foregroundColor(.white)
                    .background(Color(R.color.common.mainColor))
                    .cornerRadius(.app.corner.radiusS)
            }
        }
        .padding(.horizontal)
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
