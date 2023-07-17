//
//  CompleteView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/17.
//

import SwiftUI

struct CompleteView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(Color(red: 0.98, green: 0.07, blue: 0.31))
                .padding(10)
            
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
        
    }
}

struct CompleteView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteView()
    }
}
