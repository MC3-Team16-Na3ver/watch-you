//
//  AlarmView.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/27.
//

import SwiftUI

struct AlarmView: View {
    
    @State private var skip: String = "SKIP"
    @State private var title: String = "알람 설정"
    @State private var buttonTitle: String = "다음"
    
    var body: some View {
        VStack {
            
            OnboardingTopView(title: $title, skip: $skip)
            
            HStack {
                Rectangle()
                    .frame(width: 292, height: 4)
                    .foregroundColor(Color(UIColor.red.normal))
                
                Spacer()
            }
            .padding(.leading, -16)
            
            VStack {
                
                Text("럽둡 사용에 꼭 필요해요!")
                    .font(.system(size: 24))
                    .bold()
                
                Text("우리만의 특별한 시그널을 느껴보세요.")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                
                Image("alarm1")
                    .frame(width: 80)
                    .shadow(color: .white, radius: 2, x: 0, y: 0)
                    .shadow(color: .white, radius: 3, x: 0, y: 2)
                    .shadow(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.37), radius: 4, x: 4, y: 4)

                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(UIColor.red.normal).opacity(0.32))
                    .frame(width: 272, height: 152)
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0.8))
                    .overlay(
                        
                        VStack(alignment: .center) {
                            
                            Text("알람 권한을 허용해 주세요")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                            
                            Text("알람기능이 꺼져있으면\n사랑하는 사람이 보내는 시그널을\n알아차리기 어려워요.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 12))
                            
                            Divider()
                                .foregroundColor(Color(UIColor.red.normal).opacity(0.32))
                            
                            HStack(spacing: 0) {
                                
                                Text("허용 안 함")
                                    .frame(width: 136, height: 32)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(UIColor.gray.normal))
                                
                                Text("허용")
                                    .fontWeight(.semibold)
                                    .frame(width: 136, height: 32)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(UIColor.red.normal))
                                    .overlay(
                                        ZStack {
                                            Circle()
                                                .stroke(Color(UIColor.red.normal), lineWidth: 3)
                                                .frame(width: 72, height: 72)
                                                .blur(radius: 2)
                                        }
                                    )
                            }
                        }
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .frame(width: 272, height: 152)
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0.8))
                            )
                    )
            }
            .padding(.top, 72)
            
            Spacer()
            
            nextButton(buttonTitle: $buttonTitle)
        }
    }
}
