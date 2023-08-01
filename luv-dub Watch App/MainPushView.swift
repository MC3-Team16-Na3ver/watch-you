//
//  ContentView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/12.
//

import CoreData
import FirebaseMessaging
import SwiftUI
import UserNotifications
import WatchConnectivity

struct MainPushView: View {
    @StateObject var mainPushViewModel = MainPushViewModel()
    @FetchRequest(sortDescriptors: []) var tokens: FetchedResults<WatchToken>
    @State private var token: [WatchToken] = []
    
    private var notificationData: [String: Any] {
        let request: NSFetchRequest<WatchToken> = WatchToken.fetchRequest()
        
        do {
            token = try WatchDataController.shared.container.viewContext.fetch(request)
            
            if let loverDeviceToken = tokens.last?.loverDeviceToken {
                let notificationJSON = [
                    "message": [
                        "token": loverDeviceToken,
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
                
                return notificationJSON
            }
        } catch {
            print(error)
        }
        
        return [:]
    }
    
    var body: some View {
        VStack {
            List(tokens) { user in
                Text(user.loverDeviceToken ?? "없어")
                Text(user.refreshToken ?? "리프레시 토큰도 없어")
            }
            
            Button {
                mainPushViewModel.pushNotification(notificationData: notificationData)
                print("토큰값인디여 \(mainPushViewModel.token)")
                print("리프레시여 \(mainPushViewModel.refreshToken)")
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
            let request: NSFetchRequest<WatchToken> = WatchToken.fetchRequest()
            do {
               token = try WatchDataController.shared.container.viewContext.fetch(request)
                
                if let refreshToken = tokens.last?.refreshToken {
                    print("리프레시 토큰 값!!!!! \(refreshToken)")
                    print("디바이스1!!!! \(tokens.last?.loverDeviceToken ?? "")")
                    mainPushViewModel.refreshAccessToken(refreshToken: refreshToken)
                    mainPushViewModel.refreshToken = refreshToken
                    mainPushViewModel.token = tokens.last!.loverDeviceToken!
                }
            } catch {
                print(error)
            }
        }
    }
}

struct MainPushView_Previews: PreviewProvider {
    static var previews: some View {
        MainPushView()
    }
}
