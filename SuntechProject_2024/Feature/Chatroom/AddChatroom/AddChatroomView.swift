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
            userSections
        }
        .listStyle(.grouped)
        .loading(viewModel.isLoading)
        .onAppear {
            viewModel.fetchAllChatUser()
        }
    }
    
    private func chatUserListRow(_ user: ChatUser) -> some View {
        HStack(spacing: .app.space.spacingS) {
            Image(systemName: "person")
                .scaledToFit()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
                .background(Color.gray)
                .clipShape(Circle())
            
            Text(user.name)
                .fontWeight(.bold)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
            
        }
        .listRowBackground(Color.clear)
    }
    
    private var userSections: some View {
        Group {
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
