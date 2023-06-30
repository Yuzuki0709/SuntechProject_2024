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
            
            VStack {
               headerLogo()
            }
        }
    }
    
    private func background() -> some View {
        Color.mainColor
            .ignoresSafeArea()
    }
    
    private func headerLogo() -> some View {
        HStack(spacing: 10) {
            Text("STC")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text("サンテクノカレッジ")
                Text("Suntechno College")
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
