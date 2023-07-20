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
    @State var isLoading = false
    @State var isComplete = false
    @State private var isScaled = false
    
    var body: some View {
        //        GeometryReader { geometry in
        //            ZStack {
        //                RadialGradient(
        //                    gradient: Gradient(colors: [Color.black.opacity(0.65), Color(#colorLiteral(red: 0.9803921569, green: 0.06666666667, blue: 0.3098039216, alpha: 0.28))]),
        //                    center: .center,
        //                    startRadius: self.isScaled ? 10 : 35,
        //                    endRadius: self.isScaled ? geometry.size.width * 0.65 : geometry.size.width * 0.7
        //                )
        //                .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0.3).repeatForever(autoreverses: false))
        //
        //                DiamondShape()
        //                    .fill(RadialGradient(
        //                        gradient: Gradient(colors: [Color.black.opacity(0.12),Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.65)]),
        //                        center: .center,
        //                        startRadius: 35,
        //                        endRadius: 150
        //                    ))
        //                    .scaleEffect(2.2, anchor: .center)
        //                    .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0.5).repeatForever(autoreverses: false))
        //                SendButton(tapStatus: $tapStatus, longPressDetected: $longPressDetected, isClicked: $isClicked, isLoading: $isLoading, isComplete: $isComplete)
        //            }
        //            .edgesIgnoringSafeArea(.all)
        //            .onAppear {
        //                self.isScaled = true
        //            }
        //        }
        ZStack {
            if isComplete {
                CompleteView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            isComplete = false
                        }
                    }
            } else {
                if isLoading {
                    CircleLoadingView()
                } else {
                    SendButton(tapStatus: $tapStatus, longPressDetected: $longPressDetected, isClicked: $isClicked, isLoading: $isLoading, isComplete: $isComplete)
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


