//
//  MainViewModel.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/17.
//

import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var myData = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
    @Published var loverData = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
    @Published var path: [ViewType] = []
    @Published var users: [UserInfo] = []
    
    func getRefreshToken(completion: @escaping (String) -> Void) {
        Database.database().reference().child("notification/refresh_token").getData { error, snapShot in
            if let error = error {
                print(error.localizedDescription)
                completion("")
                return
            }
            
            if let refreshToken = snapShot?.value as? String {
                completion(refreshToken)
            }
          }
    }
    
    func addUserIdToRealtimeDatabase(deviceToken: String, loverUid: String, loversDeviceToken: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        Database.database().reference().child("User").child(currentUser.uid).setValue([
            "deviceToken": deviceToken,
            "loverUid": loverUid,
            "loversDeviceToken": loversDeviceToken,
        ])
    }
    
    func fetchDatas(completion: @escaping () -> Void) {
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
                        completion()
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
