//
//  AppStyle.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/18.
//

import SwiftUI

public enum AppStyle {}

extension CGFloat: AppCompatible {
}

public extension Extension where Base == CGFloat {
    static let space = AppStyle.SpaceLayout()
    static let corner = AppStyle.CornerRadius()
}
