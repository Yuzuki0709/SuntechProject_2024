//
//  LoginView.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/06/30.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    private let width: CGFloat = UIScreen.main.bounds.width
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                background()
                VStack(spacing: .app.space.spacingL) {
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
            .ignoresSafeArea()
            .alert("エラーが発生しました", isPresented: .constant(viewModel.state == .error)) {
                Button("OK") { viewModel.send(event: .alertPositiveButtonTap) }
            } message: {
                Text("メールアドレスとパスワードを再入力してください。")
            }
            .loading(viewModel.state == .loading)
            .overlay {
                if viewModel.state == .wait {
                    screenLock()
                }
            }
        }
    }
    
    private func background() -> some View {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color(R.color.common.mainColor),
                    Color(R.color.login.backgroundColor)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private func headerLogo() -> some View {
        HStack(spacing: .app.space.spacingXS) {
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
        VStack(spacing: .app.space.spacingM) {
            TextField("E-mail", text: $viewModel.emailText)
                .disabled(viewModel.state == .wait)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $viewModel.passwordText)
                .disabled(viewModel.state == .wait)
                .textFieldStyle(.roundedBorder)
        }
        .frame(width: width * 0.8)
    }
    
    private func loginButton() -> some View {
        Button {
            viewModel.send(event: .login)
        } label: {
            Text("Login")
                .font(.system(size: 18, weight: .semibold))
                .frame(width: width * 0.8, height: 70)
                .background(Color(R.color.common.subColor))
                .foregroundColor(.white)
                .cornerRadius(.app.corner.radiusS)
        }
        .disabled(viewModel.state == .wait)
    }
    
    private func screenLock() -> some View {
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
