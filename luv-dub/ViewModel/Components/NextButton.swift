//
//  NextButton.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/28.
//

import SwiftUI

struct nextButton: View {
    
    @Binding var buttonTitle: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 60)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1, green: 0.3, blue: 0.48),
                        Color(red: 0.98, green: 0.07, blue: 0.31)
                    ]),
                    startPoint: UnitPoint(x: 0.9, y: 1),
                    endPoint: UnitPoint(x: 0.1, y: 0))
            )
            .frame(width: 300, height: 60)
            .overlay(
                Text(buttonTitle)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.white)
            )
    }
}
