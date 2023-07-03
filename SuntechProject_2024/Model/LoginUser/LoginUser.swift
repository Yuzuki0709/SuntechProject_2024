//
//  LoginUser.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation

struct LoginUser: Decodable {
    let type: UserType
    let user: Loggable
    
    enum CodingKeys: String, CodingKey {
        case type = "userType"
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(UserType.self, forKey: .type)
        
        switch type {
        case .student:
            self.user = try container.decode(Student.self, forKey: .user)
        case .teacher:
            self.user = try container.decode(Teacher.self, forKey: .user)
        }
    }
}
