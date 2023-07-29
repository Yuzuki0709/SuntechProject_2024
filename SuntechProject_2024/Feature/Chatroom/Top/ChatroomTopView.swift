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
        VStack {
            List {
                TextField("検索", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.vertical, .app.space.spacingXXS)
                
                ForEach(0..<10) { _ in
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: .app.space.spacingXXS) {
                            Text("夕月")
                                .fontWeight(.bold)
                            Text("サンプルテキスト")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
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
                }
            }
        }
        .navigationTitle("チャット一覧")
    }
}

struct ChatroomTopView_Previews: PreviewProvider {
    static var previews: some View {
        ChatroomTopView()
    }
}
