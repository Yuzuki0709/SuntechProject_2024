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
    func fetchChatUser(userId: String, completion: @escaping ((Result<ChatUser, AFError>) -> ()))
    func fetchAllChatUser(completion: @escaping ((Result<[ChatUser], AFError>) -> ()))
    func fetchChatMessage(userId: String, roomId: Int64, completion: @escaping ((Result<[ChatMessageOfDay], AFError>) -> ()))
    
    func sendChatroom(
        userId1: String,
        userId2: String,
        roomName: String,
        completion: @escaping ((Result<Chatroom, SuntechAPIError>) -> ())
    )
    func sendChatMessage(
        userId: String,
        roomId: Int64,
        text: String,
        completion: @escaping ((Result<Void, SuntechAPIError>) -> ())
    )
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
        let path = "/api/chat/get_user"
        let parameter = [
            "user_id": "\"\(userId)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: ChatUser.self, decoder: JSONDecoder()) { response in
                completion(response.result)
            }
    }
    
    func fetchAllChatUser(completion: @escaping ((Result<[ChatUser], AFError>) -> ())) {
        let path = "/api/chat/get_all_user"
        
        AF.request(baseURL + path)
            .responseDecodable(of: [ChatUser].self, decoder: JSONDecoder()) { response in
                completion(response.result)
            }
    }
    
    func fetchChatMessage(userId: String, roomId: Int64, completion: @escaping ((Result<[ChatMessage], AFError>) -> ())) {
        let path = "/api/chat/get_message"
        let parameter = [
            "user_id": "\"\(userId)\"",
            "room_id": "\(roomId)"
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let iso8601Full = DateFormatter()
        iso8601Full.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        iso8601Full.calendar = Calendar(identifier: .iso8601)
        iso8601Full.locale = Locale(identifier: "ja_JP")
        
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: [ChatMessage].self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchChatMessage(userId: String, roomId: Int64, completion: @escaping ((Result<[ChatMessageOfDay], AFError>) -> ())) {
        let path = "/api/chat/get_message"
        let parameter = [
            "user_id": "\"\(userId)\"",
            "room_id": "\(roomId)"
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let iso8601Full = DateFormatter()
        iso8601Full.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        iso8601Full.calendar = Calendar(identifier: .iso8601)
        iso8601Full.locale = Locale(identifier: "ja_JP")
        
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: [ChatMessage].self, decoder: decoder) { response in
                switch response.result {
                case .success(let messages):
                    
                    let calendar = Calendar(identifier: .gregorian)
                    
                    let groupedMessages = Dictionary(grouping: messages) { message in
                        let dateComponents = calendar.dateComponents(
                            [.year, .month, .day],
                            from: message.sendAt
                        )
                        return calendar.date(from: dateComponents) ?? Date()
                    }
                    
                    let sortedKeys = groupedMessages.keys.sorted { a, b in
                        return a < b
                    }
                    
                    let chatMessageOfDay = sortedKeys.map { key in
                        ChatMessageOfDay(
                            dateTime: key,
                            messages: groupedMessages[key] ?? []
                        )
                    }
                    completion(.success(chatMessageOfDay))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func sendChatroom(userId1: String, userId2: String, roomName: String, completion: @escaping ((Result<Chatroom, SuntechAPIError>) -> ())) {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let iso8601Full = DateFormatter()
        iso8601Full.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        iso8601Full.calendar = Calendar(identifier: .iso8601)
        iso8601Full.locale = Locale(identifier: "ja_JP")
        
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        
        let path = "/api/chat/send_room"
        let parameter = [
            "user_id_1": "\"\(userId1)\"",
            "user_id_2": "\"\(userId2)\"",
            "room_name": "\"\(roomName)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: Chatroom.self, decoder: decoder) { response in
                guard let _ = response.data,
                      let statusCode = response.response?.statusCode else { return completion(.failure(.networkError)) }
                
                if statusCode == 200 {
                    guard let chatroom = response.value else {
                        return completion(.failure(.networkError))
                    }
                    completion(.success(chatroom))
                } else {
                    completion(.failure(.existingChatroom))
                }
            }
    }
    
    func sendChatMessage(userId: String, roomId: Int64, text: String, completion: @escaping ((Result<Void, SuntechAPIError>) -> ())) {
        let path = "/api/chat/send_message"
        let parameter = [
            "user_id": "\"\(userId)\"",
            "room_id": "\(roomId)",
            "text": "\"\(text)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .response { response in
                guard let _ = response.data else { return completion(.failure(.networkError))}
                completion(.success(()))
            }
    }
}

