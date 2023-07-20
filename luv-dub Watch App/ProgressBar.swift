//
//  ProgressBar.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/20.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var animate: Bool
    @Binding var isComplete: Bool
    @State private var isPulsing = false
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.225))
                .frame(width: 148, height: 148)
                .scaleEffect(isPulsing ? 1.16 : 1)
            Circle()
                .fill(Color(red: 0.98, green: 0.11, blue: 0.34).opacity(0.255))
                .overlay(
                    Circle()
                        .fill(.shadow(.inner(radius: 2, y: 3)))
                        .foregroundColor(Color(red: 0.98, green: 0.11, blue: 0.34).opacity(0.44)))
                .frame(width: 147, height: 147)
            
            Circle()
                .fill(.black)
                .frame(width: 118, height: 118)
                .shadow(color: Color.black, radius: 1.5, x: 0, y: 1.5)
            
            Circle()
                .trim(from: 0, to: isComplete ? 1.0 : progress)
                .stroke(
                    Color(red: 0.98, green: 0.07, blue: 0.31),
                    style: StrokeStyle(lineWidth: 8.2,
                                       lineCap: .round
                                      ))
                .frame(width: 132.5, height: 132.5)
                .rotationEffect(.degrees(-90))
            
        }
        .onAppear {
                    if animate {
                        withAnimation(Animation.linear(duration: 3.5)) {
                            self.progress = 1.0
                        }
                    }
                }
        .onChange(of: isComplete) { newValue in
            if newValue {
                Timer.scheduledTimer(withTimeInterval: 2.2, repeats: false) { _ in
                    self.isComplete = false
                }
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(animate: .constant(true), isComplete: .constant(false))
    }
}

extension Notification.Name {
    static let progressCompleted = Notification.Name("progressCompleted")
}
