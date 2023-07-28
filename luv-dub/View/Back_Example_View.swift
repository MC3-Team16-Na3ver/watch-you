//
//  TestView.swift
//  luv-dub
//
//  Created by moon on 2023/07/29.
//

import SwiftUI
import RiveRuntime

struct TestView: View {
    var body: some View {
        ZStack{
            RiveViewModel(fileName: "back_heart").view()
                .ignoresSafeArea()
                .blur(radius: 17)
            VStack{
                Text("FDSA")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
