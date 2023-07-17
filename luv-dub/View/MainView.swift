//
//  MainView.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/17.
//

import SwiftUI
import WatchConnectivity

struct MainView: View {
    @StateObject var mainViewModel = MainViewModel()
    
    var body: some View {
        HStack {
            VStack {
                Text(mainViewModel.myData.nickname)
                    .font(.callout)
                Text(mainViewModel.myData.userID)

            }

            VStack {
                Text(mainViewModel.loverData.nickname)
                    .font(.callout)
                Text(mainViewModel.loverData.userID)
            }
        }
        .onAppear {
            mainViewModel.fetchDatas()
            mainViewModel.session = WCSession.default
            mainViewModel.session?.activate()
            mainViewModel.sendDictionaryToWatch()
        }
    }
}
