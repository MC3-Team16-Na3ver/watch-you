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
        Text("{아이디}가 내 생각하는중")
            .onAppear{
                DispatchQueue.global().async {
                    triggerHapticFeedback(.stop, repetition: 5, duration: 1)
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
}

struct NotificationView_preview: PreviewProvider {
    static var previews: some View {
        Group{
            // NotificationView(title: "Eren", message: "코카콜라제로")
            NotificationView()
        }
    }
}
