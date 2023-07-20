//
//  SendButton.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/18.
//

import SwiftUI

struct SendButton: View {
    @Binding var tapStatus: String
    @Binding var longPressDetected: Bool
    @Binding var isClicked: Bool
    @Binding var isLoading: Bool
    @Binding var isComplete: Bool
    @State private var dotAnimationStart = false

    
    var body: some View {
        ZStack {
            if isClicked {
                ProgressBar(animate: $longPressDetected, isComplete: $isComplete)
                    .onReceive(NotificationCenter.default.publisher(for: .progressCompleted)) { _ in
                        self.isComplete = true
                    }
            }
            
            Button(action: {
                if self.longPressDetected {
                    self.tapStatus = "Tap Done"
                    print(tapStatus)
                    self.isClicked = false
                    longPressDetected = false
                    self.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        //                        self.isLoading = false
                        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                            self.dotAnimationStart = true
                        }
                        
                    }
                } else {
                    tapStatus = "Please Press and hold"
                    print(tapStatus)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 1, green: 0.3, blue: 0.48), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.92, y: 0.1),
                                endPoint: UnitPoint(x: 0.15, y: 0.87)
                            )
                        )
                        .frame(width: 116, height: 116)
                        .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 0)
                        .mask(Circle())
                    
                    if isClicked {
                        HStack {
                            Text("전송중.")
                                .font(
                                    Font.custom("Apple SD Gothic Neo", size: 13)
                                        .weight(.semibold)
                                )
                                .kerning(0.1)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            ForEach(0..<2, id: \.self) { index in
                                Text(".")
                                    .font(
                                        Font.custom("Apple SD Gothic Neo", size: 13)
                                            .weight(.semibold)
                                    )
                                    .kerning(0.1)
                                //                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .scaleEffect(longPressDetected ? 1.0 : 0.1)
                                //                                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.2 * Double(index)))
                            }
                        }
                    } else {
                        Text("SEND")
                            .font(
                                Font.custom("Apple SD Gothic Neo", size: 17)
                                    .weight(.bold)
                            )
                            .kerning(0.1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3)
                .onChanged { gesture in
                    if !isClicked {
                        withAnimation {
                            longPressDetected = gesture
                        }
                    }
                }
                .onEnded { gesture in
                    if !isClicked {
                        self.tapStatus = "Tap Currently Holded"
                        print(tapStatus)
                        self.isClicked = true
                        longPressDetected = true
                    }
                }
        )
    }
}

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton(tapStatus: .constant(""), longPressDetected: .constant(false), isClicked: .constant(false), isLoading: .constant(false), isComplete: .constant(false))
    }
}




