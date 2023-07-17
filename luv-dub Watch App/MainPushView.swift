//
//  ContentView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/12.
//

import SwiftUI
import UserNotifications

struct MainPushView: View {
    var body: some View {
        VStack
        {
            Button("Request permission")
            {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
                    if success{
                        print("All set")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Schedule Notification")
            {
                let content = UNMutableNotificationContent()
                content.title = "Drink some milk!"
                content.subtitle = "you have 5 sec"
                content.sound = .default
                content.categoryIdentifier = "myCategory"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "milk", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }else{
                        print("scheduled successfully")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPushView()
    }
}
