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
            if let myUid = Auth.auth().currentUser?.uid {
                Firestore.firestore().collection("User").document(myUid).addSnapshotListener { document, error in
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
}

struct CoupleCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CoupleCodeView()
    }
}
