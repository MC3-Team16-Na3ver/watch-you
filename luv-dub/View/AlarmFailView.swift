//
//  AlarmFailView.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/28.
//

import SwiftUI

struct AlarmFailView: View {
    
    @State private var skip: String = ""
    @State private var title: String = "알람 설정"
    @State private var buttonTitle: String = "설정 바로 가기"
    @State private var disabledTitle: String = "나중에"
    
    var body: some View {
        VStack {
            
            OnboardingTopView(title: $title, skip: $skip)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 4)
                .padding(.horizontal, -16)
                .foregroundColor(Color(UIColor.red.normal))
            
            VStack {
                
                Text("알람을 허용하지 않으면\n시그널을 알아차리지 못해요")
                    .font(.system(size: 24))
                    .bold()
                    .multilineTextAlignment(.center)
                
                ZStack {
                    Image("alarmfail")
                        .frame(width: 80)
                        .shadow(color: .white, radius: 2, x: 0, y: 0)
                        .shadow(color: .white, radius: 3, x: 0, y: 2)
                        .shadow(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.37), radius: 4, x: 4, y: 4)
                    
                    Image("xmark")
                        .frame(width: 52)
                        .offset(x: -32, y: 28)
                        .shadow(color: .white, radius: 2, x: 0, y: 0)
                        .shadow(color: .white, radius: 3, x: 0, y: 2)
                }
            }
            .padding(.top, 72)
            
            Spacer()
            
            nextButton(buttonTitle: $buttonTitle)
                .padding(.bottom, 16)
            
            DisabledButton(disabledTitle: $disabledTitle)
        }
    }
}
