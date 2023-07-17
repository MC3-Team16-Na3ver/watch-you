//
//  NotificationView.swift
//  luv-dub Watch App
//
//  Created by moon on 2023/07/12.
//

import SwiftUI
import WatchKit

struct NotificationView: View {
    var body: some View {
        Text("{아이디}가 내생각하는중")
            .onAppear{
                let queue = DispatchQueue(label: "com.knowstack.queue1")
                queue.async{
                    self.triggerHapticFeedback(.stop, repetition: 5, duration: 1.0)
                }
            }
    }
    
    private func triggerHapticFeedback(_ hapticType: WKHapticType, repetition: Int, duration: TimeInterval) {
        let hapticInterface = WKInterfaceDevice.current()
        
        for _ in 0..<repetition {
            hapticInterface.play(hapticType)
            Thread.sleep(forTimeInterval: duration)
        }
    }
    
    /*
    private func displayName(for hapticType: WKHapticType) -> String {
        switch hapticType {
        case .notification:
            return "Notification"
        case .directionUp:
            return "Direction Up"
        case .directionDown:
            return "Direction Down"
        case .success:
            return "Success"
        case .failure:
            return "Failure"
        case .retry:
            return "Retry"
        case .start:
            return "Start"
        case .stop:
            return "Stop"
        case .click:
            return "Click"
        case .navigationGenericManeuver:
            return "Generic Maneuver"
        case .navigationLeftTurn:
            return "Left Turn"
        case .navigationRightTurn:
            return "Right Turn"
        case .underwaterDepthPrompt:
            return "Underwater Depth Prompt"
        case .underwaterDepthCriticalPrompt:
            return "Underwater Depth Critical Prompt"
        @unknown default:
            fatalError()
        }
    }
     */
}

struct NotificationView_preview: PreviewProvider {
    static var previews: some View {
        Group{
            // NotificationView(title: "Eren", message: "코카콜라제로")
            NotificationView()
        }
    }
}
