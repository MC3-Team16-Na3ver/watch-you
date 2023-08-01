//
//  LoginViewModel.swift
//  LoveDuk
//
//  Created by Song Jihyuk on 2023/07/11.
//

import AuthenticationServices
import CoreData
import CryptoKit
import Firebase
import FirebaseAuth
import KakaoSDKAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import KakaoSDKUser
import SwiftUI

class LoginViewModel: ObservableObject {
    var nonce = "" // @Published 필요없지 않나요?
    @Published var user = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
    let auth = Auth.auth()
    @Published var path: [ViewType] = []

    // MARK: Create
    func addUserToDatabase() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Auth.auth().currentUser is null")
            return
        }
        
        self.user.userID = currentUser.uid
        self.user.deviceToken = Messaging.messaging().fcmToken!
        self.path.append(.coupleCodeView)
        
        do {
            let _ = try Firestore.firestore().collection("User").document(user.userID)
                .setData(from: self.user)
            	
        } catch {
            print(error)
        }
    }
    
    func createUserWithEmail(email: String, userName: String, password: Int64, profileImage: URL) {
        let passwordToString = String(describing: password)
        Auth.auth().createUser(withEmail: email, password: passwordToString) { result, error in
            if let error = error {
                print(error)
                return
            }
            self.loginUser(email: email, password: passwordToString)
        }
    }

    func signInWithKakao() {
        self.user = .init(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                print(error)
                if let error = error {
                }
                self.fetchUserDataFromKakao()
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error)
                }
                
                self.fetchUserDataFromKakao()
                
            }
        }
    }
    
    func fetchUserDataFromKakao() {
        UserApi.shared.me { user, error in
            if let error = error {
                print("\(error)")
                return
            }
            guard let name = user?.kakaoAccount?.profile?.nickname else { return }
            guard let email = user?.kakaoAccount?.email else { return }
            guard let id = user?.id else { return }
            guard let profileImage = user?.kakaoAccount?.profile?.profileImageUrl else { return }
            self.checkEmailForDuplication(email: email) { isDuplicated in
                if isDuplicated {
                    self.loginUser(email: email, password: String(describing: id))
                    self.path.append(.mainView)
                } else {
                   self.createUserWithEmail(email: email, userName: name, password: id, profileImage: profileImage)
                   self.updateUserModel(user: User(name: name, nickname: "", dDay: "", userID: "", email: email, deviceToken: "", connectedID: ""))
                   self.path.append(.nicknameView)
               }
            }
        }
    }
    
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) {
        self.user = .init(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
        
        guard let token = credential.identityToken else { return }
        guard let tokenString = String(data: token, encoding: .utf8) else { return }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { result, error in
            if let error = error {
                print(error)
                return
            }
            if result == nil {
                self.fetchUserDataFromApple(credential: credential)
                self.path.append(.nicknameView)
            } else {
                self.path.append(.mainView)
            }
            
        }
        
        
        
    }
    
    func fetchUserDataFromApple(credential: ASAuthorizationAppleIDCredential) {
        guard let givenName = credential.fullName?.givenName else { return }
        self.updateUserModel(user: User(name: givenName, nickname: "", dDay: "", userID: "", email: credential.email ?? "", deviceToken: "", connectedID: ""))
    }
    
    // MARK: Read
    
    // MARK: Update
    func connectUsertoUser(to loverUid: String) {
        let db = Firestore.firestore()
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        if loverUid.isEmpty {
            self.path.append(.coupleCodeView)
            return
        }
        
        db.collection("User").document(loverUid).getDocument { document, error in
            if let error = error {
                print(error)
                return
            }
            
            let currentUserData = db.collection("User").document(currentUserUid)
            let _ = currentUserData.updateData(["connectedID": loverUid])
            
            let loverUserData = db.collection("User").document(loverUid)
            let _ = currentUserData.addSnapshotListener { snapshot, error in
                if let error = error {
                    return
                }
                if let change = snapshot?.exists {
                    let _ = loverUserData.updateData(["connectedID": currentUserUid])
                    self.path.append(.successView)
                }
            }
            
            
        }
        
    }
    
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, err in
            
            if let err = err {
                print("Failed to login user", err)
                return
            }
            
            print("Succesfully logged in as user: \(result?.user.uid ?? "")")
        }
    }
    
    func updateUserModel(user: User) {
        self.user = user
        
    }
    
    
    // MARK: Delete
    
    private func checkEmailForDuplication(email: String, completion: @escaping (Bool) -> Void) {
        let query = Firestore.firestore().collection("User")
            .whereField("email", isEqualTo: email)
        
        query.getDocuments { result, error in
            var isDuplicated: Bool
            if let duplicationResult = result?.isEmpty {
                isDuplicated = !duplicationResult
            } else {
                isDuplicated = false
                
            }
            
           completion(isDuplicated)
        }
    }
        
    func cryptoUserData() -> String {
        self.nonce = randomNonceString()
        return sha256(nonce)
    }
    
     private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
     }
    
      private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    
}
