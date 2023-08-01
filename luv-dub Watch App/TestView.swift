//
//  TestView.swift
//  luv-dub Watch App
//
//  Created by Song Jihyuk on 2023/07/28.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseMessaging
import SwiftUI

struct TestView: View {
    @StateObject var mainPushViewModel = MainPushViewModel()
    
    private var notificationData: [String: Any] { [
        "message": [
            "token": "dc_HU87Jq0TTp6zgnreUbz:APA91bEjKOsa6fF_XZpydCGg-sL15ue30H9ToTZ_awsIjfRdw1VfJpHdwhwQWW4LUhPJIVDXNjkX5zdQ5jtXS_ZH5ohC7rI7xbIKYCHgW9k91Co9nG4uuEPCv8hPtVtmwiAVOXRyjXHs",
            "apns": [
                "payload": [
                    "aps": [
                        "alert" : [
                            "title" : "Game Request",
                            "subtitle" : "Five Card Draw",
                            "body" : "Bob wants to play poker"
                        ],
                        "category" : "hello"
                    ],
                ]
            ]
        ]
    ]
    }
    private func pushNotification(notificationData: [String: Any]) {
        var isRefreshed = false
        let url = URL(string: "https://fcm.googleapis.com/v1/projects/loveduk-539e3/messages:send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(mainPushViewModel.accessToken)", forHTTPHeaderField: "Authorization")
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
                        print("404임")
                    }
                    
                    if httpStatus.statusCode == 401 {
                        print("401 임 ㅠㅠ")
                        
                        isRefreshed = true
                    }
                }
                
                guard isRefreshed else { return }
            }
            
            task.resume()
        }
    }
        
//    private func addUserIdToRealtimeDatabase(deviceToken: String , loverUid: String, loversDeviceToken: String) {
//
//        Database.database().reference().child("User").child("테스트임").setValue([
//            "deviceToken": "안녕",
//            "loverUid": "하이",
//            "loversDeviceToken": "하ㅣ이하이",
//        ])
//    }
    
    var body: some View {
        
            Button("엑세스 토큰을 통해 노티를 보내요") {
                pushNotification(notificationData: notificationData)
            }
            
//            Button("리얼타임 데이터베이스에서 리프레시 토큰을 가져와요") {
//                mainPushViewModel.getRefreshToken { hello in
//                    print("안녀엉")
//                }
//            }
            
//            Button("리얼타임 데이터베이스에 업데이트 해요") {
//                addUserIdToRealtimeDatabase(deviceToken: "", loverUid: "", loversDeviceToken: "")
//                print("testtest")
//            }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
