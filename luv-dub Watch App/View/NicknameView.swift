//
//  OnboardingView.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/27.
//

import SwiftUI


extension UIColor {
    struct red {
        static let normal = UIColor(red:0.98, green:0.07, blue:0.31, alpha:1.00)
    }
    struct gray {
        static let normal = UIColor(red:0.76, green:0.76, blue:0.77, alpha:1.00)
    }
}

struct NicknameView: View {
    
    @State private var skip: String = "SKIP"
    @State private var title: String = "닉네임 설정"
    @State private var buttonTitle: String = "다음"
    
    var body: some View {
        VStack {
            
            OnboardingTopView(title: $title, skip: $skip)
            
            HStack {
                Rectangle()
                    .frame(width: 97.5, height: 4)
                    .foregroundColor(Color(UIColor.red.normal))
                
                Spacer()
            }
            .padding(.leading, -16)
            
            Spacer()
            
            Text("사용할 닉네임을 입력하세요")
                .font(.system(size: 24))
                .bold()
                .padding(.bottom, 8)
            
            Text("둘만이 사용하는 애칭을 6자 이하로 정해주세요")
                .font(.system(size: 16))
                .fontWeight(.light)
            
            Spacer()
            
            //LinearGradient, shadow 다시 확인해야함!
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: Color(red: 0.57, green: 0.57, blue: 0.57).opacity(0.24), location: 0.00),
                            Gradient.Stop(color: .white.opacity(0), location: 1.00),
                        ]),
                        startPoint: .init(x: 0.05, y: 0),
                        endPoint: .init(x: 1, y: 1)
                    )
                )
                .frame(width: 332, height: 92)
                .foregroundColor(.gray)
            //닉네임 입력 전 shadow
//              .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
            //닉네임 입력 후 shadow
//                .shadow(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.6), radius: 4, x: 0, y: 0)
            
            //닉네임 입력 전 text
//                .overlay(
//                    Text("닉네임 입력")
//                        .font(.system(size: 36))
//                        .fontWeight(.medium)
//                        .foregroundColor(Color(UIColor.gray.normal))
//                )
            //닉네임 입력 후 text
                .overlay(
                    Text("지니")
                        .font(.system(size: 36))
                        .bold()
                        .foregroundColor(Color(UIColor.red.normal))
                )
            
            Spacer()
            
            nextButton(buttonTitle: $buttonTitle)
        }
    }
}
