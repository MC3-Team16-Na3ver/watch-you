//
//  luv_dubApp.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/12.
//

import Firebase
import SwiftUI
import UserNotifications
import WatchKit

@main
struct luv_dub_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(ExtensionDelegate.self) var appDelegate: ExtensionDelegate
    
    var body: some Scene {
        WindowGroup {
            TabView{
//                TestView()
                MainPushView()
                ProfileView()
            }
        }
        
        #if os(watchOS)
        WKNotificationScene(controller: NotificationController.self, category: "hello")
        #endif
    }
}

class ExtensionDelegate: NSObject, WKApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func applicationDidFinishLaunching() {
        
    }
    
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (WKBackgroundFetchResult) -> Void) {
        handleNotification(userInfo)
        completionHandler(.newData)
    }
    
    func handleNotification(_ userInfo: [AnyHashable: Any]) {
            // 알림 처리 로직
            
            // WKNotificationScene 실행
            let notificationCenter = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            // 알림 내용 설정
            // ...
            let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: nil)
            
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Failed to add notification request: \(error.localizedDescription)")
                } else {
                    print("Notification request added successfully")
                }
            }
        }
}
