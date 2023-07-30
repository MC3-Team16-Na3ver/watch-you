//
//  StatusView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject private var viewModel: ButtonViewModel
    @State private var isAnimating  = false
    var body: some View {
        VStack {
            if viewModel.isLoading {
                BlinkingLoading(isAnimating: $isAnimating, count: 8, size:8)
                    .frame(width: 40, height: 40)
                    .padding(12)
                    .onAppear {
                        isAnimating = true
                    }
                    .onDisappear {
                        isAnimating = false
                    }
                
            } else {
                Circle()
                    .fill(Color(red: 1, green: 0.22, blue: 0.37).opacity(0.2))
                    .frame(width: 30, height: 30)
                    .padding(15)
                    .modifier(CircleCheckmarkStyle(isSuccess: viewModel.isSendComplete))
            }
            
            
            Text(viewModel.isLoading ? TransmissionStatus.inProgress.status :
                    (viewModel.isSendComplete ? TransmissionStatus.sendComplete.status :
                        TransmissionStatus.sendFail.status))
            .modifier(TextStyle(textSize: 15, textWeight: .semibold, textKerning: 0.015))
            .padding(5)
            
            
            Text(viewModel.isLoading ? TransmissionStatus.inProgress.description :
                    (viewModel.isSendComplete ? TransmissionStatus.sendComplete.description :
                            TransmissionStatus.sendFail.description ))
            .modifier(TextStyle(textSize: 10, textWeight: .regular, textKerning: 0.01))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewModel.isProgressComplete = false
                viewModel.isMainScreen = true
            }
        }
    }
}

// 완료 원 배경
struct CircleCheckmarkStyle: ViewModifier {
    let isSuccess: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Image(systemName: isSuccess ? "checkmark" : "xmark")
                    .font(Font.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 1, green: 0.22, blue: 0.37))
            )
            .padding()
    }
}


struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
            .environmentObject(ButtonViewModel())
    }
}
