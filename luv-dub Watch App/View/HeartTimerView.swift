//
//  HeartTimerView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/27.
//

import SwiftUI

struct HeartTimerView: View {
    @EnvironmentObject private var viewModel: ButtonViewModel
    
    var body: some View {
        HStack() {
            if viewModel.isMainScreen {
                Image(viewModel.remainingHearts > 0 ? "heart_active" : "heart_inactive")
                if viewModel.remainingHearts == viewModel.maxHearts {
                    Text(HeartStatus.isFull.status)
                        .modifier(TextStyle(textSize: 12, textWeight: .bold, textKerning: 0.012))
                } else {
                    Text(viewModel.timerText)
                        .modifier(TextStyle(textSize: 12, textWeight: .bold, textKerning: 0.012))
                        .onAppear {
                            if viewModel.remainingHearts < 5 {
                                viewModel.startTimer()
                            }
                        }
                }
                Spacer().frame(width: 115)
            }
            
        }
    }
}

struct HeartTimerView_Previews: PreviewProvider {
    static var previews: some View {
        HeartTimerView()
            .environmentObject(ButtonViewModel())
    }
}
