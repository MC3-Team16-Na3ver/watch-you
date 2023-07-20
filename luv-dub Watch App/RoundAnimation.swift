//
//  RoundAnimation.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/16.
//

import SwiftUI

struct RoundAnimation: View {
    @Binding var animate: Bool
    @State private var scale: CGFloat = 1.2
    
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
                        startRadius: 68 * scale,
                        endRadius: 96 * scale
                    )
                )
                .frame(width: 172, height: 172)
//                .scaleEffect(self.animate ? 1.3 : 0.5)
            
//            Circle()
//                .fill(
//                    RadialGradient(
//                        gradient: Gradient(
//                            colors: [
//                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56),
//                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0)
//                            ]
//                        ),
//                        center: UnitPoint(x: 0.5, y: 0.5),
//                        startRadius: 53 * scale,
//                        endRadius: 85 * scale
//                    )
//                )
//                .frame(width: 142, height: 142)
////                .scaleEffect(self.animate ? 1.15 : 0.5)
//                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
//            Circle()
//                .fill(
//                    RadialGradient(
//                        gradient: Gradient(
//                            colors: [
//                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.56),
//                                Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0)
//                            ]
//                        ),
//                        center: UnitPoint(x: 0.5, y: 0.5),
//                        startRadius: 53,
//                        endRadius: 85
//                    )
//                )
//                .frame(width: 114, height: 114)
//                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.3).repeatForever(autoreverses: true)) {
                if animate {
                    self.scale = 1.0
                }
            }
        }
    }
}


struct RoundAnimation_Previews: PreviewProvider {
    static var previews: some View {
        RoundAnimation(animate: .constant(true))
    }
}
