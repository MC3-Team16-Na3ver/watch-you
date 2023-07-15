//
//  NotificationController.swift
//  luv-dub Watch App
//
//  Created by moon on 2023/07/12.
//

import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    var title: String?
    var message: String?

    override var body: NotificationView {
        return NotificationView()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    override func didAppear() {
        super.didAppear()
        triggerHapticFeedback(.stop, repetition: 5, duration: 1.0)
    }

    private func triggerHapticFeedback(_ hapticType: WKHapticType, repetition: Int, duration: TimeInterval) {
        let hapticInterface = WKInterfaceDevice.current()
        
        for _ in 0..<repetition {
            hapticInterface.play(hapticType)
            Thread.sleep(forTimeInterval: duration)
        }
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        
        let notificationData = notification.request.content.userInfo as? [String: Any]
        
        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        title = alert?["title"] as? String
        message = alert?["message"] as? String
        
    }
}
