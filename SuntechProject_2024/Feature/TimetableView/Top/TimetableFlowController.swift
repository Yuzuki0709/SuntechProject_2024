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
                case .classDetail(let classData, let changeClass):
                    self.startClassDetail(classData: classData, changeClass: changeClass)
                    
                case .campusNet:
                    self.startWebView(url: URL(string: "https://sites.google.com/a/suntech.jp/campus-network")!, navigationTitle: "")
                }
            })
            .store(in: &cancellable)
    }
    
    private func startClassDetail(classData: Class, changeClass: ClassChange? = nil) {
        let classDetail = NavigationContainer.shared.classDetailFlowController((classData, changeClass))
        self.navigationController?.pushViewController(classDetail, animated: true)
        classDetail.start()
    }
    
    private func startWebView(url: URL, navigationTitle: String) {
        let webView = NavigationContainer.shared
            .webViewFlowController(
                WebViewModel(
                    url: url,
                    navigateionTitle: navigationTitle
                )
            )
        webView.start()
        self.present(webView, animated: true)
    }
}
