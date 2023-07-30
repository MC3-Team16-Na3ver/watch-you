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
                UIPasteboard.general.string = loginViewModel.auth.subStrUid() // Auth.auth().currentUser?.uid ?? ""
            } label: {
                Text(loginViewModel.auth.subStrUid())
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
            let shortUid = Auth.auth().subStrUid()
            Firestore.firestore().collection("User").document(shortUid).addSnapshotListener { document, error in
                if let error = error {
                    return
                }
                
                if let change = document?.exists {
                    loginViewModel.path.append(.successView)
                    
                }
            }
        }
        
    }
}

struct CoupleCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CoupleCodeView()
    }
}
