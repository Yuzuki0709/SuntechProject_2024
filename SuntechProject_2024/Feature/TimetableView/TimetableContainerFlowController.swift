//
//  TimetableContainerFlowController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import Foundation

final class TimetableContainerFlowController: NavigationController, TimetableFlowControllerService {
    func start() {
        startTop()
    }
    
    private func startTop() {
        let top = NavigationContainer.shared.timetableFlowController()
        setViewControllers([top], animated: true)
        top.start()
    }
}
