//
//  LoginView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/06/30.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    private let width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            background()
            
            VStack(spacing: 30) {
                headerLogo()
                appDescription()
                
                Spacer()
                    .frame(height: 10)
                
                inputLoginInfo()
                
                Spacer()
                    .frame(height: 100)
                
                loginButton()
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
    
    private func appDescription() -> some View {
        Text("--- 学内生徒専用アプリ ---")
            .foregroundColor(.white)
    }
    
    private func inputLoginInfo() -> some View {
        VStack(spacing: 20) {
            TextField("E-mail", text: $viewModel.emailText)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $viewModel.passwordText)
                .textFieldStyle(.roundedBorder)
        }
        .frame(width: width * 0.8)
    }
    
    private func loginButton() -> some View {
        Button {
            viewModel.login()
        } label: {
            Text("Login")
                .font(.system(size: 18, weight: .semibold))
                .frame(width: width * 0.8, height: 70)
                .background(Color.subColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
