//
//  SuntechAPIClient.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import Foundation
import Alamofire

public protocol SuntechAPIClientProtocol {
    func login(email: String, password: String, completion: @escaping ((Result<LoginUser, AFError>) -> ()))
    func fetchWeekTimetable(studentId: String, password: String, completion: @escaping ((Result<WeekTimetable, AFError>) -> ()))
    
    func fetchChatroomList(userId: String, completion: @escaping ((Result<[Chatroom], AFError>) -> ()))
}

final class SuntechAPIClient: SuntechAPIClientProtocol {
    let baseURL = "https://proj-r.works"
    
    func login(email: String, password: String, completion: @escaping (Result<LoginUser, AFError>) -> ()) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let path = "/api/login"
        
        let parameter = [
            "email": email,
            "password": password
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: LoginUser.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchWeekTimetable(studentId: String, password: String, completion: @escaping (Result<WeekTimetable, AFError>) -> ()) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let path = "/api/timetable"
        
        let parameter = [
            "student_id": "\"\(studentId)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: WeekTimetable.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchChatroomList(userId: String, completion: @escaping ((Result<[Chatroom], AFError>) -> ())) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let iso8601Full = DateFormatter()
        iso8601Full.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        iso8601Full.calendar = Calendar(identifier: .iso8601)
        iso8601Full.locale = Locale(identifier: "ja_JP")

        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        
        let path = "/api/chat/get_rooms"
        let parameter = [
            "user_id": "\"\(userId)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: [Chatroom].self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchChatUser(userId: String, completion: @escaping ((Result<ChatUser, AFError>) -> ())) {
        let path = "api/chat/get_user"
        let parameter = [
            "user_id": "\"\(userId)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: ChatUser.self, decoder: JSONDecoder()) { response in
                completion(response.result)
            }
    }
}
