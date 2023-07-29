//
//  AppCompatible.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/18.
//

import Foundation

public enum Extension<Base> {}

public protocol AppCompatible {}

public extension AppCompatible {
    static var app: Extension<Self>.Type {
        Extension<Self>.self
    }
}
