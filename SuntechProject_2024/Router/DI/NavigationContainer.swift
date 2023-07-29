//
//  NavigationContainer.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import Foundation
import Factory

final class NavigationContainer: SharedContainer {
    static var shared = NavigationContainer()
    var manager = ContainerManager()
    
    var loginFlowController: Factory<LoginFlowControllerService> {
        self { LoginFlowController(rootView: LoginView(viewModel: LoginViewModel())) }
    }
}
