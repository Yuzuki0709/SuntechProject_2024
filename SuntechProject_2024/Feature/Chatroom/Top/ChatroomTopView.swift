//
//  ChatroomTopView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import SwiftUI

struct ChatroomTopView: View {
    @ObservedObject var viewModel: ChatroomTopViewModel
    @State private var showImageViewer = false
    
    init(viewModel: ChatroomTopViewModel) {
        self.viewModel = viewModel
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    var body: some View {
        List {
            if let myAccount = viewModel.myAccount {
                myAccountRow(myAccount)
            }
            
            searchTextField
            if viewModel.searchText.isEmpty {
                ForEach(viewModel.chatrooms) { chatroom in
                    chatroomListRow(chatroom)
                }
            } else {
                ForEach(viewModel.searchResults) { chatroom in
                    chatroomListRow(chatroom)
                }
            }
            
        }
        .onAppear {
            viewModel.fetchChatUser()
            viewModel.fetchChatroomList()
        }
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .loading(viewModel.isLoading)
        .backgroundColor(color: Color(R.color.common.backgroundColor))
        .listStyle(.plain)
        .navigationTitle("チャット一覧")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.navigate(.addChatroom)
                } label: {
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(.white)
                }
            }
        }
        .overlay {
            ImageViewer(imageURL: URL(string: viewModel.myAccount?.iconImageUrl ?? ""),
                        isEditButtonHidden: false,
                        onBackButtonTap: { showImageViewer = false },
                        onEditButtonTap: { }
            )
            .opacity(showImageViewer ? 1 : 0)
            .animation(.default, value: showImageViewer)
        }
    }
    
    private func myAccountRow(_ user: ChatUser) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                Text(user.typeDescription)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
            UserIcon(iconUrlString: user.iconImageUrl, size: 60)
                .onTapGesture {
                    showImageViewer = true
                }
        }
        .listRowBackground(Color.clear)
    }
    
    private var searchTextField: some View {
        TextField("検索", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding(.vertical, .app.space.spacingXS)
    }
    
    private func chatroomListRow(_ chatroom: Chatroom) -> some View {
        HStack(spacing: .app.space.spacingS) {
            UserIcon(iconUrlString: chatroom.partner.iconImageUrl, size: 50)
            
            VStack(alignment: .leading, spacing: .app.space.spacingXXS) {
                Text(chatroom.partner.name)
                    .fontWeight(.bold)
                Text(chatroom.recentMessage ?? "")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack {
                Text(DateHelper.formatToString(date: chatroom.updateAt, format: "yyyy/MM/dd"))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.vertical)
        }
        .listRowBackground(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.navigate(.chatMessage(chatroom))
        }
    }
}

private extension ChatUser {
    var typeDescription: String {
        switch self.type {
        case .teacher:
            return "教師"
        case .student(let department):
            switch department {
            case .C:
                return "コンピュータコミュニケーション科"
            case .M:
                return "マルチメディア科"
            case .S:
                return "情報システム科"
            }
        case .unknownd:
            return "不明"
        }
    }
}

struct ChatroomTopView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatroomTopView(viewModel: ChatroomTopViewModel())
                .customNavigationBar(title: "チャット一覧", color: Color(R.color.common.mainColor))
        }
    }
}
