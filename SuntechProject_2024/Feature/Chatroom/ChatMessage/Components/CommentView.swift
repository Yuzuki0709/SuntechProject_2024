//
//  CommentView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/09.
//

import SwiftUI

public struct CommentView<Content: View>: View {
    let date: String
    let iconUrlString: String?
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
                UserIcon(iconUrlString: iconUrlString, size: 40)
                
                speechBubble
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var speechBubble: some View {
        HStack(alignment: .top, spacing: 0) {
            Triangle(to: .left)
                .fill(Color(R.color.timetable.backgroundColor))
                .frame(width: 8, height: 7)
                .padding(.top, 8)
            
            content()
                .padding(8)
                .background(Color(R.color.timetable.backgroundColor))
                .cornerRadius(10)
                .readSize(of: \.width, to: $contentWidth)
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(date: "12:30", iconUrlString: nil) {
            Text("あああああああ")
        }
        .padding()
        .backgroundColor(color: Color(R.color.common.backgroundColor))
    }
}
