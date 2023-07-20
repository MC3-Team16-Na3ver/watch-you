//
//  Test.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/19.
//

import SwiftUI

struct Test: View {
    @State private var isStartAnimation = false
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(
                .black
                .shadow(
                .inner(color: .red, radius: isStartAnimation ? 30 : 50))
            )
            .onReceive(timer) { _ in
                withAnimation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 0.3).repeatForever(autoreverses: false)) {
                    isStartAnimation = true
                }

            }

            .ignoresSafeArea()
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
