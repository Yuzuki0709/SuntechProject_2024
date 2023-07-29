//
//  ClassDetailFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import Foundation
import Combine

final class ClassDetailFlowController: HostingController<ClassDetailView>, ClassDetailFlowControllerService {
    private var cancellable = Set<AnyCancellable>()
    
    private var viewModel: ClassDetailViewModel {
        host.rootView.viewModel
    }
    
    override init(rootView: ClassDetailView) {
        super.init(rootView: rootView)
    }
    
    func start() {
        cancellable = Set()
        
        viewModel.navigationSignal
            .sink(receiveValue: { [weak self] navigation in
                guard let self else { return }
                switch navigation {
                case .attendanceStatus(let classData):
                    self.startAttendanceStatus(classData: classData)
                case .classroom(let url):
                    self.startClassroom(url: url)
                }
            })
            .store(in: &cancellable)
    }
    
    private func startAttendanceStatus(classData: Class) {
        let attendanceStatus = NavigationContainer.shared.attendanceStatusFlowController(classData)
        self.present(attendanceStatus, animated: true)
        attendanceStatus.start()
    }
    
    private func startClassroom(url: URL) {
        let webView = WebViewFlowController(
            rootView: WebView(
                viewModel: WebViewModel(
                    url: url,
                    navigateionTitle: ""
                )
            )
        )
        
        self.present(webView, animated: true)
        webView.start()
    }
}
