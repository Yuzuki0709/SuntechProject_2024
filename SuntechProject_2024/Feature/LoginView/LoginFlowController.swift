//
//  LoginFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/26.
//

import Foundation
import Combine

final class LoginFlowController: HostingController<LoginView>, LoginFlowControllerService {
    private var cancellable = Set<AnyCancellable>()
    
    private var viewModel: LoginViewModel {
        host.rootView.viewModel
    }
    
    override init(rootView: LoginView) {
        super.init(rootView: rootView)
    }
    
    func start() {
        cancellable = Set()
    }
}
