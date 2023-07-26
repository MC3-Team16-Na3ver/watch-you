//
//  CompleteView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import SwiftUI

struct CompleteView: View {
    @EnvironmentObject private var viewModel: ButtonViewModel
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color(red: 1, green: 0.22, blue: 0.37).opacity(0.2))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(Font.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 1, green: 0.22, blue: 0.37))
                )
                .padding()
            
            Text("전송완료")
                .font(
                    Font.custom("Apple SD Gothic Neo", size: 15)
                        .weight(.semibold)
                )
                .kerning(0.015)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(1.5)
            
            Text("상대방에게 \n 나의 마음을 보냈어요")
                .font(Font.custom("Apple SD Gothic Neo", size: 10))
                .kerning(0.01)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewModel.isProgressComplete = false
            }
        }
    }
}

struct CompleteView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteView()
    }
}
