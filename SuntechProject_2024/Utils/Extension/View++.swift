//
//  View++.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/10.
//

import SwiftUI

extension View {
    func halfModal<Sheet: View>(
        isShow: Binding<Bool>,
        @ViewBuilder sheet: @escaping () -> Sheet,
        onClose: @escaping () -> ()
    ) -> some View {
        return self
            .background(
                HalfModalSheetViewController(sheet: sheet(), isShow: isShow, onClose: onClose)
            )
    }
    
    func customNavigationBar(title: String, color: Color) -> some View {
        self.modifier(CustomNavigationBar(title: title, color: color))
    }
    
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifer(backgroundColor: backgroundColor))
    }
    
    func navigationBackButton(color: Color, onTap: @escaping (() -> Void)) -> some View {
        self.modifier(NavigationBackButton(color: color, onTap: onTap))
    }
}
