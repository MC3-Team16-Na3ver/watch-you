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

enum InvitationCode {
    case nonexist
    case exist
}
struct CoupleCodeView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var invitationCode: String = ""
    @State private var codeExistence: InvitationCode?
    
    var body: some View {
        VStack {
            Text("나의 코드 복사")
            
            Button {
                UIPasteboard.general.string = invitationCode
            } label: {
                Text(invitationCode)
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
            loadInvitationCode()
        }
    }

    private func loadInvitationCode() {
        guard let userUid = Auth.auth().currentUser?.uid else {
            return
        }

        Firestore.firestore().collection("User").document(userUid).getDocument { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = querySnapshot?.data(), let code = data["invitationCode"] as? String, !code.isEmpty {
                self.invitationCode = code
                
            } else {
                self.invitationCode = createInvitationCode()
                checkInvitationCodeDuplication(invitationCode: self.invitationCode) { result in
                    switch result {
                    case .exist:
                        loadInvitationCode()
                    case .nonexist:
                        Firestore.firestore().collection("User").document(userUid)
                            .updateData(["invitationCode" : invitationCode])
                    }
                }
                
            }
        }
    }
    
    private func checkInvitationCodeDuplication(invitationCode: String, completion: @escaping (InvitationCode) -> Void) {
        let query = Firestore.firestore().collection("User")
            .whereField("invitationCode", isEqualTo: invitationCode)
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                completion(.exist)
            } else {
                completion(.nonexist)
            }
        }
    }
    
    private func createInvitationCode() -> String {
        let element = "0123456789"
        let invitationCode = element.createRandomString(length: 6)
        
        return invitationCode
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

extension String {
    func createRandomString(length: Int) -> String {
        let str    = (0..<length).map { _ in self.randomElement()! }
        return String(str)
    }
}
