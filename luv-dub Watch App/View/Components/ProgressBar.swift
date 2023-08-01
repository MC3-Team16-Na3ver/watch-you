//
//  ProgressBar.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import SwiftUI

struct ProgressBar: View {
    @EnvironmentObject private var viewModel: ButtonViewModel
    @State private var scale: CGFloat = 1.2
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(
                            colors: [
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.36),
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0)
                            ]
                        ),
                        center: UnitPoint(x: 0.5, y: 0.5),
                        startRadius: 55 * scale,
                        endRadius: 75 * scale
                    )
                )
                .frame(width: 147, height: 147)
                .scaleEffect(viewModel.longPressDetected ? 1.15 : 0.8)
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
                .trim(from: 0, to: viewModel.longPressDetected ? viewModel.progress : 0)
                .stroke(
                    Color(red: 0.98, green: 0.07, blue: 0.31),
                    style: StrokeStyle(lineWidth: 8.2, lineCap: .round)
                )
                .frame(width: 132.5, height: 132.5)
                .rotationEffect(.degrees(-90))
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                if viewModel.longPressDetected {
                    self.scale = 1.0
                }
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar()
            .environmentObject(ButtonViewModel())
    }
}
