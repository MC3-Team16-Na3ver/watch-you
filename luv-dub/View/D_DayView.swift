//
//  D_DayView.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/27.
//

import SwiftUI

struct D_DayView: View {
    
    @State var date = Date()
    @State private var skip: String = "SKIP"
    @State private var title: String = "디데이 설정"
    @State private var buttonTitle: String = "다음"
    
    var body: some View {
        VStack {
            
            OnboardingTopView(title: $title, skip: $skip)
            
            HStack {
                Rectangle()
                    .frame(width: 195, height: 4)
                    .foregroundColor(Color(UIColor.red.normal))
                Spacer()
            }
            .padding(.leading, -16)
            
            Spacer()
            
            Text("우리의 기념일을 입력하세요")
                .font(.system(size: 24))
                .bold()
                .padding(.bottom, 8)
            
            Text("2022년 10월 1일")
                .font(.system(size: 32))
                .fontWeight(.semibold)
                .foregroundColor(Color(UIColor.red.normal))
            
            Spacer()
            
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(.wheel)
                .padding(.trailing, 20)
            
            Spacer()
            
            nextButton(buttonTitle: $buttonTitle)
        }
    }
}
