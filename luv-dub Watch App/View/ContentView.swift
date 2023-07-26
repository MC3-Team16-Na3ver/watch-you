//
//  ContentView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SendButtonView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ButtonViewModel())
    }
}
