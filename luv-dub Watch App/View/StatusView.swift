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
            BlinkingLoading(isAnimating: $isAnimating, count: 8, size:8)
                .frame(width: 40, height: 40)
                .padding(12)
                .onAppear {
                    isAnimating = true
                }
                .onDisappear {
                    isAnimating = false
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
}
