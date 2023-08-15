//
//  UIApplication++.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/08/14.
//

import UIKit

public extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
