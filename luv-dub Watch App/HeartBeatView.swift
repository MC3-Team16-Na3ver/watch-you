//
//  HeartBeatView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/19.
//

import SwiftUI

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let length = min(rect.size.width, rect.size.height)
        let middle = CGPoint(x: rect.midX, y: rect.midY)
        let offset = length * 0.002
        
        path.move(to: CGPoint(x: middle.x, y: middle.y - length * 0.5))
        path.addQuadCurve(to: CGPoint(x: middle.x + length * 0.5, y: middle.y),
                          control: CGPoint(x: middle.x + offset, y: middle.y - offset))
        path.addQuadCurve(to: CGPoint(x: middle.x, y: middle.y + length * 0.5),
                          control: CGPoint(x: middle.x + offset, y: middle.y + offset))
        path.addQuadCurve(to: CGPoint(x: middle.x - length * 0.5, y: middle.y),
                          control: CGPoint(x: middle.x - offset, y: middle.y + offset))
        path.addQuadCurve(to: CGPoint(x: middle.x, y: middle.y - length * 0.5),
                          control: CGPoint(x: middle.x - offset, y: middle.y - offset))
        
        path.closeSubpath()
        
        return path
    }
}


struct HeartBeatView: View {
    @State private var isScaled = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.65), Color(#colorLiteral(red: 0.9803921569, green: 0.06666666667, blue: 0.3098039216, alpha: 0.28))]),
                    center: .center,
                    startRadius: self.isScaled ? 10 : 25,
                    endRadius: self.isScaled ? geometry.size.width * 0.65 : geometry.size.width * 0.8
                )
                .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0.3).repeatForever(autoreverses: false))

                DiamondShape()
                    .fill(RadialGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.095),Color(red: 0.98, green: 0.07, blue: 0.31).opacity(0.25)]),
                        center: .center,
                        startRadius: 35,
                        endRadius: 150
                    ))
                    .scaleEffect(self.isScaled ? 2.4 : 1.8, anchor: .center)
//                    .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0.3).repeatForever(autoreverses: false))
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.isScaled = true
            }
        }
    }
}


struct HeartBeatView_Previews: PreviewProvider {
    static var previews: some View {
        HeartBeatView()
    }
}
