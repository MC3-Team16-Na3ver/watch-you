//
//  SendButton.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/18.
//

import SwiftUI

import SwiftUI

struct SendButton: View {
    @Binding var tapStatus: String
    @Binding var longPressDetected: Bool
    @Binding var isClicked: Bool
    @Binding var isLoading: Bool
    @Binding var isComplete: Bool
    
    var body: some View {
        Button(action: {
            if self.longPressDetected {
                self.tapStatus = "Tap Done"
                print(tapStatus)
                self.isClicked = false
                longPressDetected = false
                self.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false // 2초 후에 로딩 뷰를 숨기기 위해 isLoading을 false로 설정
                    self.isComplete = true // 완료 뷰를 표시하기 위해 isComplete를 true로 설정
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
                    RoundAnimation(animate: $longPressDetected)
                }
                
                VStack {
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
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.3).onEnded({ _ in
                self.tapStatus = "Tap Currently Holded"
                print(tapStatus)
                self.isClicked = true
                longPressDetected = true
            })
        )
    }
}

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton(tapStatus: .constant(""), longPressDetected: .constant(false), isClicked: .constant(false), isLoading: .constant(false), isComplete: .constant(false))
    }
}




