//
//  SuccessView.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/17.
//

import SwiftUI

struct SuccessView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var userInfo: FetchedResults<UserInfo>
    
    var body: some View {
        VStack {
            Text("진동을 주고받아보세요")
            
            Spacer()
            
            Button {
                let user = UserInfo(context: moc)
                user.id = loginViewModel.user.id
                user.uid = loginViewModel.user.userID
                user.nickname = loginViewModel.user.nickname
                
                try? moc.save()
                loginViewModel.path.append(.mainView)
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.pink)
                    
            }
            .frame(height: 40)
            .overlay(Text("완료!").bold())
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
