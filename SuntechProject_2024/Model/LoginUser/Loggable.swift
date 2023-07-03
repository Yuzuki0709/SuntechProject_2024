//
//  Loggable.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

protocol Loggable: Codable {
    var id: String { get }
    var password: String { get }
    var emailAddress: String { get }
}
