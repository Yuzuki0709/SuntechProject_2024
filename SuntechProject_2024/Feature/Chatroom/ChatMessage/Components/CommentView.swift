//
//  CommentView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/09.
//

import SwiftUI

public struct CommentView<Content: View>: View {
    let date: String
    @ViewBuilder var content: () -> Content
    
    @State private var contentWidth: CGFloat = .zero
    
    public var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Spacer()
                
                Text(date)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .frame(width: contentWidth)
            
            
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                speechBubble
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var speechBubble: some View {
        HStack(alignment: .top, spacing: 0) {
            Triangle(to: .left)
                .frame(width: 8, height: 7)
                .foregroundColor(.white)
                .padding(.top, 8)
            
            content()
                .padding(8)
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .readSize(of: \.width, to: $contentWidth)
        }
    }
    
    init(date: String, content: @escaping () -> Content) {
        self.date = date
        self.content = content
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView( date: "12:30") {
            Text("あああああああ")
        }
        .padding()
        .backgroundColor(color: Color(R.color.common.backgroundColor))
    }
}
