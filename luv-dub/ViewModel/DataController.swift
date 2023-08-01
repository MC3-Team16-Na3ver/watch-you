//
//  DataController.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/26.
//

import CoreData
import SwiftUI

class DataController {
    let container = NSPersistentContainer(name: "UserProgress")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUserInfo() {
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
    }
    
    func deleteUserInfo(userInfo: UserInfo) {
        container.viewContext.delete(userInfo)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
    }
    
    func getAllUserInfo() -> [UserInfo] {
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func save(nickname: String) {
        let userInfo = UserInfo(context: container.viewContext)
        userInfo.nickname  = nickname
        
        do {
           try container.viewContext.save()
        } catch {
            print("Failed to save")
        }
    }
}
