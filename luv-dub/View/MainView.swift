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
    var vieModelPhone = ViewModelPhone()
    
    var body: some View {
        HStack {
            VStack {
                Text(mainViewModel.myData.nickname)
                    .font(.callout)
                Text(mainViewModel.myData.userID)

            }
            
            Button {
                self.vieModelPhone.session.sendMessage(["token": mainViewModel.loverData.deviceToken], replyHandler: nil) { error in
                    print(error.localizedDescription)
                }
            } label: {
                Text("UPDATE")
            }

            VStack {
                Text(mainViewModel.loverData.nickname)
                    .font(.callout)
                Text(mainViewModel.loverData.userID)
            }
        }
        .onAppear {
            mainViewModel.fetchDatas()

        }
    }
}
