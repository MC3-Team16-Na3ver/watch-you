//
//  DataController.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/26.
//

import CoreData
import SwiftUI

class WatchDataController {
    static let shared = WatchDataController()
    let container = NSPersistentContainer(name: "WatchInfo")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateToken() {
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
    }
    
    func deleteToken(userInfo: WatchToken) {
        container.viewContext.delete(userInfo)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
    }
    
    func getAllWatchInfo() -> [WatchToken] {
        let fetchRequest: NSFetchRequest<WatchToken> = WatchToken.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func saveRemainingHearts(_ remainingHearts: Int) {
        let fetchRequest: NSFetchRequest<WatchToken> = WatchToken.fetchRequest()
        
        do {
            let watchInfo = try container.viewContext.fetch(fetchRequest).first ?? WatchToken(context: container.viewContext)
            watchInfo.remainingHearts = Int16(remainingHearts)
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
    }
    
    func loadRemainingHearts() -> Int {
        let fetchRequest: NSFetchRequest<WatchToken> = WatchToken.fetchRequest()
        
        do {
            let watchInfo = try container.viewContext.fetch(fetchRequest).first
            return Int(watchInfo?.remainingHearts ?? 5)
        } catch {
            return 5
        }
    }
}
