//
//  MyCommentView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/07.
//

import SwiftUI

struct MyCommentView<Content: View>: View {
    let date: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .trailing, spacing: .app.space.spacingXXS) {
            Text(date)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.trailing, .app.space.spacingXXS)
            
            speechBubble
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    init(date: String, content: @escaping () -> Content) {
        self.date = date
        self.content = content
    }
    
    private var speechBubble: some View {
        HStack(alignment: .top, spacing: 0) {
            content()
                .padding(.app.space.spacingXS)
                .foregroundColor(.white)
                .background(Color(R.color.common.mainColor))
                .cornerRadius(10)
            
            Triangle(to: .right)
                .frame(width: 8, height: 8)
                .foregroundColor(Color(R.color.common.mainColor))
                .padding(.top, .app.space.spacingXS)
        }
    }
}

struct MyCommentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MyCommentView(date: "9:30") {
                Text("ああああああああああああああああああああああああああああああああああああああああ")
            }
            MyCommentView(date: "12.00") {
                Text("aaaaaaaaaaaaaa")
            }
        }
    }
}
