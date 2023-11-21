//
//  SuntechAPIClient.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/03.
//

import SwiftUI
import Alamofire

public protocol SuntechAPIClientProtocol {
    func login(email: String, password: String, completion: @escaping ((Result<LoginUser, DomainError>) -> ()))
    func fetchWeekTimetableFirst(studentId: String, password: String, completion: @escaping ((Result<WeekTimetable, AFError>) -> ()))
    func fetchWeekTimetableSecond(studentId: String, password: String, completion: @escaping ((Result<WeekTimetable, AFError>) -> ()))
    func fetchVacations(completion: @escaping ((Result<[Vacation], AFError>) -> ()))
    func fetchCancelClass(completion: @escaping ((Result<[ClassCancellation], AFError>) -> ()))
    func fetchChangeClass(completion: @escaping ((Result<[ClassChange], AFError>) -> ()))
    
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
    func sendUserIcon(
        userId: String,
        userIcon: UIImage,
        completion: @escaping ((Result<Void, SuntechAPIError>) -> ())
    )
}

final class SuntechAPIClient: SuntechAPIClientProtocol {
    let baseURL = "https://proj-r.works"
    
    func login(email: String, password: String, completion: @escaping (Result<LoginUser, DomainError>) -> ()) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let path = "/api/login"
        
        let parameter = [
            "email": email,
            "password": password
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: LoginUser.self, decoder: decoder) { response in
                if let error = response.error {
                    switch error {
                    case .responseSerializationFailed(_):
                        completion(.failure(.loginFailure))
                    default:
                        completion(.failure(.network))
                    }
                }
                guard let loginUser = response.value else { return }
                completion(.success(loginUser))
            }
    }
    
    func fetchWeekTimetableFirst(studentId: String, password: String, completion: @escaping (Result<WeekTimetable, AFError>) -> ()) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let path = "/api/timetable_first"
        
        let parameter = [
            "student_id": "\"\(studentId)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: WeekTimetable.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchWeekTimetableSecond(studentId: String, password: String, completion: @escaping (Result<WeekTimetable, AFError>) -> ()) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let path = "/api/timetable_second"
        
        let parameter = [
            "student_id": "\"\(studentId)\""
        ]
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: WeekTimetable.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchVacations(completion: @escaping ((Result<[Vacation], AFError>) -> ())) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let iso8601Full = DateFormatter()
        iso8601Full.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        iso8601Full.calendar = Calendar(identifier: .iso8601)
        iso8601Full.locale = Locale(identifier: "ja_JP")
        
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        
        let path = "/api/timetable/get_vacations"
        
        AF.request(baseURL + path)
            .responseDecodable(of: [Vacation].self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchCancelClass(completion: @escaping ((Result<[ClassCancellation], AFError>) -> ())) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let iso8601Full = DateFormatter()
        iso8601Full.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        iso8601Full.calendar = Calendar(identifier: .iso8601)
        iso8601Full.locale = Locale(identifier: "ja_JP")
        
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        
        let path = "/api/timetable/get_cancellation"
        
        AF.request(baseURL + path)
            .responseDecodable(of: [ClassCancellation].self, decoder: decoder) { response in
                completion(response.result)
            }
        
    }
    
    func fetchChangeClass(completion: @escaping ((Result<[ClassChange], AFError>) -> ())) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let iso8601Full = DateFormatter()
        iso8601Full.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        iso8601Full.calendar = Calendar(identifier: .iso8601)
        iso8601Full.locale = Locale(identifier: "ja_JP")
        
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
        
        let path = "/api/timetable/get_change"
        
        AF.request(baseURL + path)
            .responseDecodable(of: [ClassChange].self, decoder: decoder) { response in
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
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(baseURL + path, parameters: parameter)
            .responseDecodable(of: ChatUser.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func fetchAllChatUser(completion: @escaping ((Result<[ChatUser], AFError>) -> ())) {
        let path = "/api/chat/get_all_user"
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(baseURL + path)
            .responseDecodable(of: [ChatUser].self, decoder: decoder) { response in
                print(response.result)
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
    
    func sendUserIcon(userId: String, userIcon: UIImage, completion: @escaping ((Result<Void, SuntechAPIError>) -> ())) {
        let path = "/api/chat/uploadIcon?user_id=\(userId)"
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        guard let imageData = userIcon.jpegData(compressionQuality: 1.0) else { return completion(.failure(.unknown)) }
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "user_icon", fileName: "image.jpg", mimeType: "image/jpeg")
            },
            to: baseURL + path,
            method: .post,
            headers: headers
        )
        .response { response in
            if let statusCode = response.response?.statusCode {
                if case 200...299 = statusCode {
                    completion(.success(()))
                } else {
                    completion(.failure(.networkError))
                }
            } else {
                completion(.failure(.unknown)) // Handle other cases
            }
        }
    }
}

