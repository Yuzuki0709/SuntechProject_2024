//
//  MainFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/27.
//

import Foundation
import UIKit

final class MainFlowController: UIViewController, MainFlowControllerService {
    private let embeddedTabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.embeddedTabBarController = tabBarController
        super.init(nibName: nil, bundle: nil)
        addContent(embeddedTabBarController)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        let viewControllers = MainTabType.allCases.map(createViewController)
        embeddedTabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    private func createViewController(with tab: MainTabType) -> UIViewController {
        guard let viewController = tab.flowController else {
            assertionFailure("FlowController for \(tab) not register")
            return UIViewController()
        }
        viewController.tabBarItem = tab.tabBarItem
        viewController.start()
        return viewController
    }
}

private extension MainTabType {
    var flowController: (any FlowController)? {
        switch self {
        case .timetable:
            return NavigationContainer.shared.timetableContainerFlowController()
        case .chatroom:
            // TODO: チャット画面ができたら書き換える
            return TimetableFlowController(rootView: TimetableView(viewModel: TimetableViewModel()))
        }
    }
}
