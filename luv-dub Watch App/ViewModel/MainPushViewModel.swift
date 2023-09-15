//
//  MainPushViewModel.swift
//  luv-dub Watch App
//
//  Created by Song Jihyuk on 2023/07/21.
//

import CoreData
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseMessaging
import SwiftUI
import WatchConnectivity

class MainPushViewModel: NSObject, WCSessionDelegate, ObservableObject {
    let watchDataController = WatchDataController.shared
    var session: WCSession
    
    let FIREBASEUID = "NXkfsqsdkcZHpBoLzeG9qi9ktmJ2"
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        var viewContext: NSManagedObjectContext {
            watchDataController.container.viewContext
        }
        
        let user = WatchToken(context: viewContext)
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
        }
    }
    
    func createRequest()-> URLRequest {
        let url = URL(string: "https://asia-northeast3-loveduk-539e3.cloudfunctions.net/fcm")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = [
            "deviceToken": FIREBASEUID
        ]
        let jsonBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonBody
        
        return request
    }

    func testIDLE() async -> CompleteViewStatus {
        Thread.sleep(forTimeInterval: 2)
        return .IDLE
    }
    
}
