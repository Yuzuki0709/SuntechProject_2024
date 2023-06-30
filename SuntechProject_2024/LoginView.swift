//
//  LoginView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/06/30.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            background()
        }
    }
    
    private func background() -> some View {
        Color.mainColor
            .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
