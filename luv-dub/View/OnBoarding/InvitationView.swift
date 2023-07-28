//
//  MainView.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/17.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseMessaging
import SwiftUI

struct InvitationView: View {
    @State private var invitationCode = ""
    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("연인의 커플 코드를 입력해 주세요.")
            
            TextField("코드 입력", text: $invitationCode)
            
            Spacer()
            
            Button {
                loginViewModel.connectUsertoUser(to: invitationCode)
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.pink)
                    .overlay(
                        Text("연결하기")
                            .foregroundColor(.white)
                            .bold()
                    )
            }
            .disabled(invitationCode.isEmpty)
        }
    }
}
