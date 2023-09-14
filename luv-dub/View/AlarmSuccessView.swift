//
//  AlarmSuccessView.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/30.
//

import SwiftUI

struct AlarmSuccessView: View {
    
    @State private var skip: String = ""
    @State private var title: String = "알람 설정"
    @State private var buttonTitle: String = "시작하기"
    
    var body: some View {
        VStack {
            
            OnboardingTopView(title: $title, skip: $skip)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 4)
                .padding(.horizontal, -16)
                .foregroundColor(Color(UIColor.red.normal))
            
            VStack {
                
                Text("이제 연인에게서\n시그널을 받아 볼 수 있어요!")
                    .font(.system(size: 24))
                    .bold()
                    .multilineTextAlignment(.center)
                
                ZStack {
                    Image("successCircle")
                        .frame(width: 80)
                        .shadow(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.37), radius: 4, x: 4, y: 4)
                    
                    Image("successHeart")
                        .opacity(0.5)
                        .frame(width: 80)
                    //x: 숫자가 작야아 오른쪽으로 감, y: 숫자가 작아야 위로 올라감
                        .offset(x: -16, y: 20)
                        .shadow(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.37), radius: 4, x: 4, y: 4)
                        .shadow(color: .white, radius: 2, x: 0, y: 0)
                        .shadow(color: .white, radius: 3, x: 0, y: 2)
                }
            }
            .padding(.top, 72)
            
            Spacer()
            
            nextButton(buttonTitle: $buttonTitle)
        }
    }
}
