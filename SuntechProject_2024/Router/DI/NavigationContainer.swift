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
    
    var classDetailFlowController: ParameterFactory<(Class,ClassChange?), ClassDetailFlowControllerService> {
        self { (classData, changeClass) in
            ClassDetailFlowController(
                rootView: ClassDetailView(
                    viewModel: ClassDetailViewModel(
                        classData: classData
                    ),
                    changeClass: changeClass
                )
            )
        }
    }
    
    var attendanceStatusFlowController: ParameterFactory<Class, AttendanceStatusFlowControllerService> {
        self { classData in
            AttendanceStatusFlowController(
                rootView: AttendanceStatusView(
                    viewModel: AttendanceStatusViewModel(classData: classData)
                )
            )
        }
    }
    
    var chatroomContainerFlowController: Factory<ChatroomFlowControllerService> {
        self { ChatroomContainerFlowController() }
    }
    
    var chatroomTopFlowController: Factory<ChatroomFlowControllerService> {
        self { ChatroomTopFlowController(rootView: ChatroomTopView(viewModel: ChatroomTopViewModel())) }
    }
    
    var addChatroomFlowController: Factory<AddChatroomFlowControllerService> {
        self { AddChatroomFlowController(rootView: AddChatroomView(viewModel: AddChatroomViewModel())) }
    }
    
    var chatMessageFlowController: ParameterFactory<Chatroom, ChatMessageFlowControllerService> {
        self { chatroom in
            ChatMessageFlowController(
                rootView: ChatMessageView(
                    viewModel: ChatMessageViewModel(chatroom: chatroom)
                )
            )
        }
    }
    
    var webViewFlowController: ParameterFactory<WebViewModel, WebViewFlowControllerService> {
        self { viewModel in
            WebViewFlowController(rootView: WebView(viewModel: viewModel))
        }
    }
}
