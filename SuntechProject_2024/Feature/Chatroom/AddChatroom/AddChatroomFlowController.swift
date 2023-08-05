//
//  AddChatroomFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/01.
//

import Foundation
import Combine

final class AddChatroomFlowController: HostingController<AddChatroomView>, AddChatroomFlowControllerService {
    
    private var cancellable = Set<AnyCancellable>()
    
    private var viewModel: AddChatroomViewModel {
        host.rootView.viewModel
    }
    
    override init(rootView: AddChatroomView) {
        super.init(rootView: rootView)
    }
    
    func start() {
    }
}
