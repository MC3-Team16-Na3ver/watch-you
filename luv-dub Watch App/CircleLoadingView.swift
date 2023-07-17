//
//  CircleLoadingView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/16.
//

import SwiftUI

struct CircleLoadingView: View {
    @State private var isLoading = false
    private let numberOfDots = 60
    private let dotSpacingAngle: Double = 360.0 / 60
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: isLoading ? 1 : 0)
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, dash: [2, 16]))
                .frame(width: 138, height: 138)
                .foregroundColor(Color(red: 0.98, green: 0.07, blue: 0.31))
                .rotationEffect(Angle.degrees(-90))
                .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
            Text("전송중")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(.semibold)
                )
                .kerning(0.015)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(1.5)
        }
        .onAppear {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false 
            }
        }
    }
    
}

struct CircleLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CircleLoadingView()
    }
}
