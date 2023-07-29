//
//  TimetableFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import UIKit
import Combine

final class TimetableFlowController: HostingController<TimetableView>, TimetableFlowControllerService {
    private var cancellable = Set<AnyCancellable>()
    
    private var viewModel: TimetableViewModel {
        host.rootView.viewModel
    }
    
    override init(rootView: TimetableView) {
        super.init(rootView: rootView)
    }
    
    func start() {
        cancellable = Set()
        
        viewModel.navigationSignal
            .sink(receiveValue: { [weak self] navigation in
                guard let self else { return }
                
                switch navigation {
                case .classDetail(let classData):
                    self.startClassDetail(classData: classData)
                }
            })
            .store(in: &cancellable)
    }
    
    private func startClassDetail(classData: Class) {
        let classDetail = ClassDetailFlowController(
            rootView: ClassDetailView(
                classData: classData,
                viewModel: ClassDetailViewModel(classData: classData)
            )
        )
        
        self.navigationController?.pushViewController(classDetail, animated: true)
        classDetail.start()
    }
}
