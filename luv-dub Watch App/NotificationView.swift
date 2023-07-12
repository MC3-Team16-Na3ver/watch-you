//
//  NotificationView.swift
//  luv-dub Watch App
//
//  Created by moon on 2023/07/12.
//

import SwiftUI

struct NotificationView: View {
    var title: String?
    var message: String?
    
    var body: some View {
        VStack {
            Text(title ?? "Unknown User")
            Text(message ?? "...")
        }
        .padding()
    }
}

struct NotificationView_preview: PreviewProvider {
    static var previews: some View {
        Group{
            NotificationView(title: "Eren", message: "코카콜라제로")
            NotificationView()
        }
    }
}
