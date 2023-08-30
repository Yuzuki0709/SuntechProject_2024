//
//  AddChatroomView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/01.
//

import SwiftUI

struct AddChatroomView: View {
    @ObservedObject var viewModel: AddChatroomViewModel
    
    init(viewModel: AddChatroomViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            searchTextField
            userSections
        }
        .listStyle(.grouped)
        .loading(viewModel.isLoading)
        .backgroundColor(color: Color(R.color.common.backgroundColor))
        .onAppear {
            viewModel.fetchAllChatUser()
        }
        .alert("確認", isPresented: .constant(viewModel.selectedUser != nil), actions: {
            Button("No") {}
            Button("Yes") {
                viewModel.sendChatroom()
            }
        }, message: {
            if let name = viewModel.selectedUser?.name {
                Text("\(name)とのチャットを開始しますか？")
            }
        })
        .alert("エラー", isPresented: .constant(viewModel.apiError != nil), actions: {
            Button("OK") { viewModel.apiError = nil }
        }, message: {
            if let error = viewModel.apiError {
                Text(error.description)
            }
        })
        .navigationTitle("チャット追加")
    }
    
    private var searchTextField: some View {
        TextField("検索", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
    private func chatUserListRow(_ user: ChatUser) -> some View {
        HStack(spacing: .app.space.spacingS) {
            UserIcon(iconUrlString: user.iconImageUrl, size: 35)
                .onAppear {
                    print(user.name)
                    print(user.iconImageUrl)
                }
            
            Text(user.name)
                .fontWeight(.bold)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
            
        }
        .padding(.vertical, .app.space.spacingXXS)
        .listRowBackground(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectedUser = user
        }
    }
    
    
    @ViewBuilder
    private var userSections: some View {
        if !viewModel.searchText.isEmpty {
            ForEach(viewModel.searchResults) { user in
                chatUserListRow(user)
            }
        } else {
            Section("教師") {
                ForEach(viewModel.chatUsers.filter { $0.type == .teacher }) { user in
                    chatUserListRow(user)
                }
            }
            Section("コンピュータ・コミュニケーション科") {
                ForEach(viewModel.chatUsers.filter { $0.type == .student(.C) }) { user in
                    chatUserListRow(user)
                }
            }
            Section("情報システム科") {
                ForEach(viewModel.chatUsers.filter { $0.type == .student(.S) }) { user in
                    chatUserListRow(user)
                }
            }
            Section("マルチメディア科") {
                ForEach(viewModel.chatUsers.filter { $0.type == .student(.M) }) { user in
                    chatUserListRow(user)
                }
            }
        }
    }
}

struct AddChatroomView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatroomView(viewModel: AddChatroomViewModel())
    }
}
