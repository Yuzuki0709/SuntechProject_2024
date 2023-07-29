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
    
    var mainFlowController: Factory<MainFlowControllerService> {
        self { MainFlowController(tabBarController: MainTabBarController()) }
    }
    
    var timetableContainerFlowController: Factory<TimetableFlowControllerService> {
        self { TimetableContainerFlowController() }
    }
    
    var timetableFlowController: Factory<TimetableFlowControllerService> {
        self {
            TimetableFlowController(
                rootView: TimetableView(
                    viewModel: TimetableViewModel(
                        suntechAPIClient: SuntechAPIClient()
                    )
                )
            )
        }
    }
    
    var classDetailFlowController: ParameterFactory<Class, ClassDetailFlowControllerService> {
        self { classData in
            ClassDetailFlowController(
                rootView: ClassDetailView(
                    viewModel: ClassDetailViewModel(
                        classData: classData
                    )
                )
            )
        }
    }
}
