//
//  CoupleCodeView.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/17.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct CoupleCodeView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack {
            Text("나의 코드 복사")
            
            Button {
                UIPasteboard.general.string = Auth.auth().currentUser?.uid ?? ""
            } label: {
                Text("\(Auth.auth().currentUser?.uid ?? "")")
                    .underline()
            }
            
            Spacer()
            
            NavigationLink {
                InvitationView()
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.pink)
                    .overlay(
                        Text("상대방 코드로 연결하기")
                            .foregroundColor(.white)
                    )
            }
        }
        .onAppear {
            listeningLoversResponse()
        }
    }
    
    private func listeningLoversResponse() {
        guard let myUid = Auth.auth().currentUser?.uid else { return }
            Firestore.firestore().collection("User").document(myUid).addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let document = documentSnapshot else { return }
                
                
                if document.exists {
                    guard let connectedID = document.data()?["connectedID"] as? String else { return }
                    
                    if !connectedID.isEmpty {
                        loginViewModel.path.append(.successView)
                    }
                }
            }
    }
}
