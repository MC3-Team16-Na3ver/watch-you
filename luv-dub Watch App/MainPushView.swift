//
//  ContentView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/12.
//

import FirebaseMessaging
import SwiftUI
import UserNotifications
import WatchConnectivity

struct MainPushView: View {
 
    
    var body: some View {
        VStack {
            Button {
                pushNotification()
            } label: {
                Circle()
                    .fill(.red)
                    .overlay {
                        Text("SEND")
                    }
            }
        }

    }
    
    private func pushNotification() {
        let token = Messaging.messaging().fcmToken
        print(token)
        
        let url = URL(string: "https://fcm.googleapis.com/v1/projects/loveduk-539e3/messages:send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer ya29.a0AbVbY6N7OAvM8H7aGHfqO-6EqQ5SsaAElFHJ5Z29_G5FbO-BvtwpotTLY12UUGDumZ4rWMw4hCn6mttXzB7A3qWqA6rDNZlYHX12DfHBz_eDrxu-HQ97gfdzitTQzAjR1zlZiZi6OCtW0cMdsP8xZLDiXWXTaCgYKAXYSARASFQFWKvPlRZE3MOtnAx8QFtMAr_egkQ0163", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let notificationData: [String: Any] = [
            "message": [
                "token": mainViewModel.token,
               "notification": [
                 "body": "This is an FCM notification message!",
                 "title": "FCM Message"
               ]
            ]
        ]
        let a = try! JSONSerialization.data(withJSONObject: notificationData, options: [])
        
        request.httpBody = a // notificationData.description.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error= \(error)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPushView()
    }
}
