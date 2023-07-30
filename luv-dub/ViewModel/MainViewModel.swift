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
    @Published var myData = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "", invitationCode: "")
    @Published var loverData = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "", invitationCode: "")
    @Published var path: [ViewType] = []
    @Published var users: [UserInfo] = []
    
    func getRefreshToken(completion: @escaping (String) -> Void) {
        let db = Firestore.firestore().collection("Token").document("refresh_token")
            .getDocument { snapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                
                if let data = snapshot?.data(), let refreshToken = data["token"] as? String {
                    completion(refreshToken)
                    print("호출됏나--- \(refreshToken)")
                }
            }
    }
    
    func addUserIdToRealtimeDatabase(deviceToken: String, loverUid: String, loversDeviceToken: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("User").child(currentUser.uid)
        ref.keepSynced(true)
        ref.setValue([
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
