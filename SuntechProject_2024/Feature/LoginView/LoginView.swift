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
        NavigationView {
            ZStack {
                NavigationLink(destination: TimetableView(),
                               isActive: .constant(viewModel.loginUser != nil)) {
                    EmptyView()
                }
                
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
            .alert("エラーが発生しました", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") { viewModel.error = nil }
            } message: {
                Text("メールアドレスとパスワードを再入力してください。")
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                            .opacity(0.3)
                        ProgressView()
                    }
                }
            }
            .overlay {
                if viewModel.isLock {
                    ZStack {
                        Color.black
                            .ignoresSafeArea()
                            .opacity(0.6)
                        
                        VStack {
                            Text("現在ログインできません")
                                .font(.title2)
                                .padding()
                            Text("\(viewModel.lockoutDurationDiffMinuteNow + 1)分後にやり直してください")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                    }
                    .background(.ultraThinMaterial)
                }
            }
        }
    }
    
    private func background() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [.mainColor, Color(R.color.login.backgroundColor)]),
            startPoint: .top,
            endPoint: .bottom
        )
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
                .disabled(viewModel.isLock)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $viewModel.passwordText)
                .disabled(viewModel.isLock)
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
        .disabled(viewModel.isLock)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}