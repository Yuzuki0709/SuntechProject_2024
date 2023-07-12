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
        guard !isExisting(classId: classId),
              let localRealm = localRealm else { return }
        
        do {
            try localRealm.write {
                let newClassAttendance = ClassAttendance(value: [
                    "classId": classId,
                    "logs": []
                ])
                
                localRealm.add(newClassAttendance)
                getClassAttendances()
            }
        } catch {
            print(error)
        }
    }
    
    func getClassAttendance(classId: String) -> ClassAttendance? {
        guard isExisting(classId: classId),
              let localRealm = localRealm else { return nil }
        
        let predicate = NSPredicate(format: "classId == %@", classId)
        return localRealm.objects(ClassAttendance.self).filter(predicate).first
    }
    
    func addAttendanceLog(classId: String, status: AttendanceStatus, date: Date) {
        guard isExisting(classId: classId),
              let localRealm = localRealm else { return }
        
        do {
            try localRealm.write {
                let predicate = NSPredicate(format: "classId == %@", classId)
                guard let changeClassAttendance = localRealm.objects(ClassAttendance.self).filter(predicate).first else { return }
                
                let log = AttendanceLog(value: ["date": date, "status": status])
                changeClassAttendance.logs.append(log)
                getClassAttendances()
            }
        } catch {
            print(error)
        }
    }
}
