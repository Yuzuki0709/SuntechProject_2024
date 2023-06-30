//
//  LoginView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/06/30.
//

import SwiftUI

struct LoginView: View {
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    
    var body: some View {
        ZStack {
            background()
            
            VStack {
                headerLogo()
                inputLoginInfo()
            }
            .padding()
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
    
    private func inputLoginInfo() -> some View {
        VStack(spacing: 20) {
            TextField("E-mail", text: $emailText)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $passwordText)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
