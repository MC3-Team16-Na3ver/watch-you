//
//  DataController.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/26.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "UserInfo")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
