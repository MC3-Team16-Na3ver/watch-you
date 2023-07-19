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
    
    
    func fetchDatas() {
        let db = Firestore.firestore().collection("User")
        let currentUserUid = Auth.auth().currentUser!.uid
        db.document(currentUserUid).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.myData = user
                print(self.myData.connectedID.description)
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
