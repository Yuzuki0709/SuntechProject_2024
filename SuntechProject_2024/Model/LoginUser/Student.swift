//
//  Student.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

struct Student: Loggable {
    let id: String
    let name: String
    let departmentId: Department
    let entranceYear: Int
    let emailAddress: String
}
