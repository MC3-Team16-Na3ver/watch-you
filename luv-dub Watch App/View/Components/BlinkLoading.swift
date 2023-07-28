//
//  BlinkLoading.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import SwiftUI

struct BlinkingLoading: View {
    @Binding var isAnimating: Bool
    public let count: Int
    public let size: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                item(forIndex: index, in: geometry.size)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
            }
        }
        .aspectRatio(contentMode: .fit)
    }
    
    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
        let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
        let x = (geometrySize.width/2 - size/2) * cos(angle)
        let y = (geometrySize.height/2 - size/2) * sin(angle)
        return Circle()
            .fill(Color(red: 1, green: 0.22, blue: 0.37))
            .frame(width: size, height: size)
            .scaleEffect(isAnimating ? 0.5 : 0.9)
            .opacity(isAnimating ? 0.25 : 1)
            .animation(
                Animation
                    .default
                    .repeatCount(isAnimating ? .max : 1, autoreverses: true)
                    .delay(Double(index) / Double(count) / 2.5)
            )
            .offset(x: x, y: y)
    }
}

struct BlinkLoading_Previews: PreviewProvider {
    static var previews: some View {
        BlinkingLoading(isAnimating: .constant(true), count: 8, size: 16)
    }
}
