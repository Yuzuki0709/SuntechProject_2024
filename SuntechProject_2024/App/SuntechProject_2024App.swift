//
//  SuntechProject_2024App.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/06/30.
//

import SwiftUI

@main
struct SuntechProject_2024App: App {
    var body: some Scene {
        WindowGroup {
            UIViewControllerAdapor(loginFlowController())
        }
    }
    
    private func loginFlowController() -> UIViewController {
        let login = LoginFlowController(rootView: LoginView(viewModel: LoginViewModel()))
        login.start()
        return login
    }
}
