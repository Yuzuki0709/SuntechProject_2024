//
//  UIViewController++.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/26.
//

import UIKit

public extension UIViewController {
    func addContent(_ viewController: UIViewController, _ current: UIViewController? = nil) {
        if let current {
            removeContent(current)
        }
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        viewController.didMove(toParent: self)
    }

    func removeContent(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    func removeAllContentViewController() {
        for child in children.reversed() {
            removeContent(child)
        }
    }
}

