//
//  MessageTextField.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/11.
//

import SwiftUI

struct MessageTextField: View {
    @ObservedObject var viewModel: ChatMessageViewModel
    
    var body: some View {
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
                    .background(viewModel.messageText.isEmpty ? .gray :  Color(R.color.common.mainColor))
                    .cornerRadius(.app.corner.radiusS)
            }
            .disabled(viewModel.messageText.isEmpty)
        }
        .padding(.horizontal)
    }
}
