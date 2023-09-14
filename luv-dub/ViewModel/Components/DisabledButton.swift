//
//  DisabledView.swift
//  luv-dub
//
//  Created by 박지은 on 2023/07/29.
//

import SwiftUI

struct DisabledButton: View {
    
    @Binding var disabledTitle: String
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 60)
            .fill(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .white, location: 0.00),
                        Gradient.Stop(color: Color(red: 0.95, green: 0.95, blue: 0.95), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
            .frame(width: 300, height: 60)
            .overlay(
                Text(disabledTitle)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color(UIColor.gray.normal))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 60)
                    .stroke(Color(UIColor.gray.normal).opacity(0.4))
            )
    }
}
