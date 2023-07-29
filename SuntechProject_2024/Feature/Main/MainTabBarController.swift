//
//  MainTabBarController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/27.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        
        let itemAppearance = UITabBarItemAppearance(style: .stacked)
        let selectedColor = R.color.common.mainColor()!
        itemAppearance.selected.iconColor = selectedColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        
        appearance.stackedLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
