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
    var body: some View {
        Text("Hello")
    }
}


struct HeartBeatView_Previews: PreviewProvider {
    static var previews: some View {
        HeartBeatView()
    }
}
