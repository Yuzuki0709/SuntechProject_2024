//
//  Class.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

struct Class: Identifiable, Codable {
    let id: String
    let name: String
    let teacher: Teacher
    let creditsCount: Int
    let timeCount: Int
}
