//
//  RoundAnimation.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/16.
//

import SwiftUI

struct RoundAnimation: View {
    @Binding var animate: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(
                            colors: [
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56),
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0)
                            ]
                        ),
                        center: UnitPoint(x: 0.5, y: 0.5),
                        startRadius: 65,
                        endRadius: 95
                    )
                )
                .frame(width: 156, height: 165)
                .scaleEffect(self.animate ? 1.3 : 1)
//                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(
                            colors: [
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56),
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0)
                            ]
                        ),
                        center: UnitPoint(x: 0.5, y: 0.5),
                        startRadius: 53,
                        endRadius: 85
                    )
                )
                .frame(width: 134, height: 134)
                .scaleEffect(self.animate ? 1.2 : 1)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(
                            colors: [
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56),
                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0)
                            ]
                        ),
                        center: UnitPoint(x: 0.5, y: 0.5),
                        startRadius: 53,
                        endRadius: 85
                    )
                )
                .frame(width: 114, height: 114)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)

        }
        .onAppear{
            animate.toggle()
        }
        .animation(animate ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default, value: animate)
        
    }
}


struct RoundAnimation_Previews: PreviewProvider {
    static var previews: some View {
        RoundAnimation(animate: .constant(true))
    }
}
