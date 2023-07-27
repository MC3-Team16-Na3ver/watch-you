//
//  MainPushViewModel.swift
//  luv-dub Watch App
//
//  Created by Song Jihyuk on 2023/07/21.
//

import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseMessaging
import SwiftUI
import WatchConnectivity

struct RefreshToken: Codable {
    let accessToken: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

class MainPushViewModel: NSObject, WCSessionDelegate, ObservableObject {
    @Published var accessToken = ""
    @Published var token = ""
    @Published var refreshToken = ""
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        self.token = userInfo["token"] as? String ?? "UNKNOWN"
        self.refreshToken = userInfo["refreshToken"] as? String ?? "UNKNOWN"
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.token = message["token"] as? String ?? "UNKNOWN"
        }
    }
    
    func pushNotification(notificationData: [String: Any]) {
        var isRefreshed = false
        let url = URL(string: "https://fcm.googleapis.com/v1/projects/loveduk-539e3/messages:send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let jsonBody = try! JSONSerialization.data(withJSONObject: notificationData, options: [])
        request.httpBody = jsonBody
        DispatchQueue.main.async {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                if httpStatus.statusCode == 404 {
                    
                }
                    
                    if httpStatus.statusCode == 401 {
                        self.refreshAccessToken(refreshToken: self.refreshToken)
                        isRefreshed = true
                    }
                }
                
                guard isRefreshed else { return }
                self.pushNotification(notificationData: notificationData)
            }
            
            task.resume()
        }
    }
    
    
    func updateDeviceToken() {
        Database.database().reference().child("User")
    }
    
    func listenToRealtimeDatabase() {
        let databashPath = Database.database().reference().child("notification")
        
        databashPath
            .observe(.value) {[weak self] snapShot, _  in
                guard let json = snapShot.value as? [String:Any] else { return }
                do {
                    let data = try JSONSerialization.data(withJSONObject: json)
                    let token = try JSONDecoder().decode(RefreshToken.self, from: data)
                    guard let accessToken = token.accessToken else { return }
                    guard let refreshToken = token.refreshToken else { return }
                    self?.accessToken = accessToken
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func stopListening() {
        Database.database().reference().removeAllObservers()
    }
    
    func getRefreshToken(completion: @escaping (String) -> Void) {
        Database.database().reference().child("notification/refresh_token").getData { error, snapShot in
            if let error = error {
                print(error.localizedDescription)
                completion("")
                return
            }
            
            if let refreshToken = snapShot?.value as? String {
                completion(refreshToken)
            }
          }
    }
    
    func refreshAccessToken(refreshToken: String) {
        let urlString = "https://oauth2.googleapis.com/token"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let clientID = "757153338890-7mk8qhu88bkjfgcvsctrrachpbudaad9.apps.googleusercontent.com"
        let clientSecret = "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&refresh_token=\(refreshToken)"
        let data = "client_id=\(clientID)&client_secret=\(clientSecret)&grant_type=refresh_token".data(using: .utf8)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {     
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(RefreshToken.self, from: data)
                if let accessToken = jsonData.accessToken {
                    self.accessToken = accessToken
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
