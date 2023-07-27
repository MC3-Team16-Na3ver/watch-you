//
//  TextStyle.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/27.
//

import Foundation
import SwiftUI

// 폰트 설정
struct TextStyle: ViewModifier {
    var textSize: CGFloat
    var textWeight: Font.Weight
    var textKerning: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Apple SD Gothic Neo", size: textSize).weight(textWeight))
            .kerning(textKerning)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
    }
}
