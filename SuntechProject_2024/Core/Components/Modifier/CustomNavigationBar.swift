//
//  CustomNavigationBar.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/17.
//

import SwiftUI

struct CustomNavigationBar: ViewModifier {
    let title: String
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(UIColor(color))
    }
}

