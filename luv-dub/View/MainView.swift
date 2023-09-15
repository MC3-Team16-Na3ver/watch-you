//
//  MainView.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/17.
//

import SwiftUI
import WatchConnectivity

struct MainView: View {
    @State var user: User = User.shared
    var viewModelPhone = ViewModelPhone()
    @State private var syncNotice = ""
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        VStack {
            Text(syncNotice)
            
            NavigationLink {
                CoupleCodeView()
            } label: {
                Text("커플 연동하기")
            }

            
            Button {
                connectedwithWatch()
            } label: {
                Text("UPDATE")
            }
            
            HStack {
                VStack {
                    Text(user.nickname ?? "닉네임")
                        .font(.callout)
                    Text(user.userID ?? "uid")
                    
                }
                
                VStack {
                    Text("상대방의 닉네임")
                        .font(.callout)
                    Text("상대방의 uid")
                }
            }
            .onAppear {
                let localUser = UserInfo(context: moc)
                
                localUser.id = self.user.id
                localUser.nickname = self.user.nickname
                localUser.uid = self.user.userID
                localUser.connectedID = self.user.connectedID
                    
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
