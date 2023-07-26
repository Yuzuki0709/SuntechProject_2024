//
//  HostingController.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/26.
//

import SwiftUI

open class HostingController<Content: View>: UIViewController {
    public var host: UIHostingController<Content>

    override public var navigationItem: UINavigationItem {
        host.navigationItem
    }

    public init(rootView: Content) {
        self.host = .init(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
        addContent(host)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
