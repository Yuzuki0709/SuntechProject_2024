//
//  NavigationBackButton.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/17.
//

import SwiftUI

struct NavigationBackButton: ViewModifier {
    let color: Color
    let onTap: () -> ()
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    buckButton
                }
            }
    }
    
    private var buckButton: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 18)
                    .font(Font.title3.bold())
                    
                Text("Back")
                    
            }
            .foregroundColor(.white)
        }
    }
}
