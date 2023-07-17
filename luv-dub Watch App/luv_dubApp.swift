//
//  luv_dubApp.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/12.
//

import SwiftUI

@main
struct luv_dub_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            MainPushView()
            // NotificationView()
        }
        
        #if os(watchOS)
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
        #endif
    }
}
