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
        getClassAttendances()
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
    
    private func getClassAttendances() {
        guard let localRealm = localRealm else { return }
        let allClassAttendaces = localRealm.objects(ClassAttendance.self).sorted(byKeyPath: "classId")
        
        classAttendances = []
        
        for classAttendance in allClassAttendaces {
            guard !classAttendance.isInvalidated else { continue }
            classAttendances.append(classAttendance)
        }
    }
    
    func isExisting(classId: String) -> Bool {
        return classAttendances.contains(where: { $0.classId == classId })
    }
    
    func addClassAttendance(classId: String) {
        guard isExisting(classId: classId),
              let localRealm = localRealm else { return }
        
        do {
            try localRealm.write {
                let newClassAttendance = ClassAttendance(value: [
                    "classId": classId,
                    "logs": []
                ])
                
                localRealm.add(classAttendances)
                getClassAttendances()
            }
        } catch {
            print(error)
        }
    }
}
