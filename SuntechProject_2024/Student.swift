//
//  Student.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

struct Student: Codable {
    let id: String
    let name: String
    let departmentId: Deparment
    let entranceYear: Int
    let password: String
    let emailAddress: String
}
