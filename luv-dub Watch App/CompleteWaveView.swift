//
//  P23_Waves.swift
//  Fabula
//
//  Created by jasu on 2021/09/06.
//  Copyright (c) 2021 jasu All rights reserved.
//

import SwiftUI

public struct P23_Waves: View {
    
    let color = Color(hex: 0xFA114F) // , Color(hex: 0x1D427B), Color(hex: 0x1D427B), Color(hex: 0x1D427B), Color(hex: 0x1D427B)] //, Color(hex: 0x285D99), Color(hex: 0x3476BA), Color(hex: 0x4091DA), Color(hex: 0x54A7E2), Color(hex: 0x71BDEB), Color(hex: 0x91D3F3), Color(hex: 0xB5E8FC)]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var time: Double = 3600 - 1
    
    public init() {}
    public var body: some View {
        GeometryReader { proxy in
            VStack{
                HStack(alignment: .center){
                    Spacer()
                    ZStack {
                        Color(hex: 0x727272)
                        WaveView(waveColor: color, waveHeight: 4 * 0.007, progress: 1 - time / 3600)
                        Text("Send")
                            .foregroundColor(Color.white)
                    }
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 0)
                    .frame(width: proxy.minSize * 0.8, height: proxy.minSize  * 0.8)
                    .mask( Circle() )
                    Spacer()
                }
                Text(String(Int(time) / 60) + ":" + String(Int(time) % 60))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .onReceive(timer) { _ in
                        self.time = self.time - 1
                        if(self.time <= 0) { self.time = 0 }
                    }
                Slider(value: $time, in: 0...3600 - 1)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

fileprivate
struct WaveShape: Shape {
    
    var offset: Angle
    var waveHeight: Double = 0.025
    var percent: Double = 0.5
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let waveHeight = waveHeight * rect.height
        let yoffset = CGFloat(1.0 - percent) * (rect.height - 6 * waveHeight)
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 361)
        
        p.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 8) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}

fileprivate
struct WaveView: View {
    
    var waveColor: Color
    var waveHeight: Double = 0.025
    var progress: Double
    
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            WaveShape(offset: waveOffset, waveHeight: waveHeight, percent: progress)
                .fill(waveColor)
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: CGFloat(waveHeight * 100)).repeatForever(autoreverses: false)) {
                    self.waveOffset = Angle(degrees: 360)
                }
            }
        }
    }
}

struct P23_Waves_Previews: PreviewProvider {
    static var previews: some View {
        P23_Waves()
    }
}
