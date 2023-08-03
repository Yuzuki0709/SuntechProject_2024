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
            
        }
        .onAppear {
            viewModel.fetchAllChatUser()
        }
    }
}

struct AddChatroomView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatroomView(viewModel: AddChatroomViewModel())
    }
}
