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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.65), Color(#colorLiteral(red: 0.9803921569, green: 0.06666666667, blue: 0.3098039216, alpha: 0.28))]),
                    center: .center,
                    startRadius: 25,
                    endRadius: geometry.size.width * 0.68
                )
                
                DiamondShape()
                    .fill(RadialGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.13),Color.clear]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    ))
                    .scaleEffect(2.4, anchor: .center)
                SendButton(tapStatus: $tapStatus, longPressDetected: $longPressDetected, isClicked: $isClicked, isLoading: $isLoading, isComplete: $isComplete)
            }
            .edgesIgnoringSafeArea(.all)
        }
//        ZStack {
//            if isComplete {
//                CompleteView()
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
//                            isComplete = false
//                        }
//                    }
//            } else {
//                if isLoading {
//                    CircleLoadingView()
//                } else {
//                    SendButton(tapStatus: $tapStatus, longPressDetected: $longPressDetected, isClicked: $isClicked, isLoading: $isLoading, isComplete: $isComplete)
//                }
//
//            }
//
//
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


