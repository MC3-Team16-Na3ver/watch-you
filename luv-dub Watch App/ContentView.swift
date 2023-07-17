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


