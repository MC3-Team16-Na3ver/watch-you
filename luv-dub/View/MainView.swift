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
    var viewModelPhone = ViewModelPhone()
    @State private var syncNotice = ""
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>

    var body: some View {
        VStack {

            Text(syncNotice)
            
            Button {
                self.viewModelPhone.session.sendMessage(["token": mainViewModel.loverData.deviceToken], replyHandler: nil) { error in
                    print(error.localizedDescription)
                }
                connectedwithWatch()
            } label: {
                Text("UPDATE")
            }
            
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
                let user = UserInfo(context: moc)
                self.mainViewModel.getRefreshToken { refreshToken in
                    self.viewModelPhone.session.transferUserInfo(["token": mainViewModel.loverData.deviceToken, "refreshToken": refreshToken])
                }
                
                    mainViewModel.fetchDatas() {
                        mainViewModel.addUserIdToRealtimeDatabase(deviceToken: mainViewModel.myData.deviceToken, loverUid: mainViewModel.loverData.userID, loversDeviceToken: mainViewModel.loverData.deviceToken)
                    }

                
                    user.id = mainViewModel.myData.id
                    user.nickname = mainViewModel.myData.nickname
                    user.uid = mainViewModel.myData.userID
                    user.connectedID = mainViewModel.myData.connectedID
                    
                    try? moc.save()
                
            }
        }
    }
    
    private func connectedwithWatch() {
        if viewModelPhone.session.isReachable {
            self.syncNotice = "워치와 연동되는 중\nupdate 버튼을 눌러주세요"
        } else {
            self.syncNotice = "워치와 연동되고 있지 않아요. 워치 화면을 켜주시고 update 버튼 눌러주세여"
        }
    }
}
