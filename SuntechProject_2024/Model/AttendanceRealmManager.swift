//
//  AttendanceRealmManager.swift
//  SuntechProject_2024
//
//  Created by 岩本竜斗 on 2023/07/11.
//

import Foundation
import RealmSwift

final class AttendanceRealmManager: ObservableObject {
    static let shared = AttendanceRealmManager()
    
    private var localRealm: Realm?
    @Published var classAttendances: [ClassAttendance] = []
    
    init() {
        openRealm()
    }
    
    private func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
}
