//
//  ChatroomTopView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import SwiftUI

struct ChatroomTopView: View {
    @State private var searchText: String = ""
    var body: some View {
        List {
            searchTextField
            ForEach(0..<10) { _ in
                chatroomListRow
            }
        }
        .backgroundColor(color: Color(R.color.attendanceStatus.backgroundColor))
        .listStyle(.plain)
        .navigationTitle("チャット一覧")
    }
    
    private var searchTextField: some View {
        TextField("検索", text: $searchText)
            .textFieldStyle(.roundedBorder)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding(.vertical, .app.space.spacingXS)
    }
    
    private var chatroomListRow: some View {
        HStack(spacing: .app.space.spacingS) {
            Image(systemName: "person")
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: .app.space.spacingXXS) {
                Text("山田太郎")
                    .fontWeight(.bold)
                Text("サンプルテキスト")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack {
                Text("7/29")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.vertical)
        }
        .listRowBackground(Color.clear)
    }
}

struct ChatroomTopView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatroomTopView()
                .customNavigationBar(title: "チャット一覧", color: Color(R.color.mainColor))
        }
    }
}
