//
//  MainViewModel.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/17.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var myData = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
    @Published var loverData = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
    @Published var path: [ViewType] = []
    let auth = Auth.auth()
    
    func fetchDatas() {
        let db = Firestore.firestore().collection("User")
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        db.document(currentUserUid).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.myData = user
                if self.myData.connectedID.isEmpty {
                    self.loverData.nickname = "연인과 연동해보세요"
                    return
                }
                
                db.document(self.myData.connectedID).getDocument(as: User.self) { data in
                    switch data {
                    case .success(let lover):
                        self.loverData = lover
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
