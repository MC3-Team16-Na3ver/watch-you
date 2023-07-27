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
    @StateObject var mainPushViewModel = MainPushViewModel()
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<UserInfo>
    private var notificationData: [String: Any] { [
        "message": [
            "token": mainPushViewModel.token,
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
    
    var body: some View {
        VStack {
            Button {
                mainPushViewModel.pushNotification(notificationData: notificationData)
                print(mainPushViewModel.token)
            }
            label: {
                Circle()
                    .fill(.red)
                    .overlay {
                        Text("SEND")
                    }
            }

        }
        .onAppear {
            mainPushViewModel.refreshAccessToken(refreshToken: mainPushViewModel.refreshToken)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPushView()
    }
}
