//
//  HeartNumbersView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/27.
//

import SwiftUI

struct HeartNumbersView: View {
    @EnvironmentObject private var viewModel: ButtonViewModel
    
    var body: some View {
        if viewModel.isMainScreen {
            HStack(spacing: 16){
                ForEach(0..<viewModel.maxHearts, id:\.self) { index in
                    Image(index < viewModel.remainingHearts ? "heart_active" : "heart_inactive")
                }
            }
        } else {
            
        }
        
    }
}

struct HeartNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        HeartNumbersView()
            .environmentObject(ButtonViewModel())
    }
}
