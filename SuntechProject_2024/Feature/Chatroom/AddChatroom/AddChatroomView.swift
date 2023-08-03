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
            ForEach(viewModel.chatUsers) { user in
                chatUserListRow(user)
            }
        }
        .listStyle(.plain)
        .loading(viewModel.isLoading)
        .onAppear {
            viewModel.fetchAllChatUser()
        }
    }
    
    private func chatUserListRow(_ user: ChatUser) -> some View {
        HStack(spacing: .app.space.spacingS) {
            Image(systemName: "person")
                .foregroundColor(.white)
                .padding()
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
}

struct AddChatroomView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatroomView(viewModel: AddChatroomViewModel())
    }
}
