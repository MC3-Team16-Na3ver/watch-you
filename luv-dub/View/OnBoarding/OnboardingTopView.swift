//
//  TopView.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/28.
//

import SwiftUI

struct OnboardingTopView: View {
    
    @Binding var title: String
    @Binding var skip: String
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .frame(width: 32)
                .foregroundColor(Color(UIColor.red.normal))
                .padding(.leading, -20)
            
            Spacer()
            
            Text(title)
                .font(.system(size: 20))
                .bold()
            
            Spacer()
            
            Text(skip)
                .font(.system(size: 16))
                .bold()
                .foregroundColor(Color(UIColor.gray.normal))
                .padding(.trailing, -12)
        }
        .padding()
    }
}

