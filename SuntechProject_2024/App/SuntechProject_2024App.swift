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
                .ignoresSafeArea()
        }
    }
    
    private func loginFlowController() -> UIViewController {
        let login = NavigationContainer.shared.loginFlowController()
        login.start()
        return login
    }
}
