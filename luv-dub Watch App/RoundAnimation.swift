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
                    EllipticalGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56), location: 0.65),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0), location: 1.00),
                        ],
                        center: UnitPoint(x: 0.5, y: 0.5)
                    )
                )
                .frame(width: 156, height: 156)
                .scaleEffect(self.animate ? 1.5 : 0.001)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
            Circle()
                .fill(
                    EllipticalGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56), location: 0.65),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0), location: 1.00),
                        ],
                        center: UnitPoint(x: 0.5, y: 0.5)
                    )
                )
                .frame(width: 134, height: 134)
                .scaleEffect(self.animate ? 1.25 : 0.001)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
            Circle()
                .fill(
                    EllipticalGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56), location: 0.65),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0), location: 1.00),
                        ],
                        center: UnitPoint(x: 0.5, y: 0.5)
                    )
                )
                .frame(width: 114, height: 114)
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
