//
//  NavigationController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/29.
//

import UIKit

open class NavigationController: UINavigationController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        setUp()
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setUp()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUp() {
        navigationBar.prefersLargeTitles = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = R.color.mainColor()
        let tintColor = UIColor.white
        navigationBar.tintColor = tintColor
        appearance.titleTextAttributes = [.foregroundColor: tintColor]
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance
        
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance = nil
        }
    }
}
