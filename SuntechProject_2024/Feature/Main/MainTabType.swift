//
//  MainTabType.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/27.
//

import Foundation
import UIKit

enum MainTabType: Int, CaseIterable {
    case timetable
    case chatroom
    
    var title: String {
        switch self {
        case .timetable:
            return "時間割"
        case .chatroom:
            return "チャット"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .timetable:
            return UIImage(systemName: "calendar")
        case .chatroom:
            return UIImage(systemName: "message.fill")
        }
    }
}

extension MainTabType {
    var tabBarItem: UITabBarItem {
        UITabBarItem(title: title, image: icon, tag: rawValue)
    }
}
