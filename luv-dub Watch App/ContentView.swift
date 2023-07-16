//
//  ContentView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/12.
//

import SwiftUI

struct ContentView: View {
    @State var tapStatus = ""
    @State var longPressDetected = false
    @State var isClicked = false
    var body: some View {
        Button(action: {
            if self.longPressDetected {
                self.tapStatus = "Tap Done"
                print(tapStatus)
                self.isClicked = false
                longPressDetected = false
            } else {
                tapStatus = "Please Press and hold"
                print(tapStatus)
            }
            
        }){
            ZStack {
                if isClicked { RoundAnimation(animate: $longPressDetected) }
                
                VStack{
                    Text("SEND")
                        .font(
                            Font.custom("Apple SD Gothic Neo", size: 17)
                                .weight(.bold)
                        )
                        .kerning(0.1)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .frame(width: 116, height: 116)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 0)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.3, blue: 0.48), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.92, y: 0.1),
                        endPoint: UnitPoint(x: 0.15, y: 0.87)
                    )
                )
            .mask(Circle())
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.1).onEnded({ _ in
                self.tapStatus = "Tap Currently Holded"
                print(tapStatus)
                self.isClicked = true
                longPressDetected = true
            })
        )
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
