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
    @Published var nonce = ""
    @Published var user = User(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
    @Published var path: [ViewType] = []

    
    //MARK: KAKAO
    func signInWithKakao() {
        self.user = .init(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
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
            
            self.checkIfUserAlreadyRegistered(email: email) { isRegistered in
                if isRegistered {
                    self.login(email: email, password: String(describing: id))
                    self.path.append(.mainView)
                } else {
                   self.createUserInAuth(email: email, userName: name, password: id, profileImage: profileImage)
                   self.updateUserModel(user: User(name: name, nickname: "", dDay: "", userID: "", email: email, deviceToken: "", connectedID: ""))
                   self.path.append(.nicknameView)
               }
            }
        }
    }
    
    //MARK: APPLE
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) {
        self.user = .init(name: "", nickname: "", dDay: "", userID: "", email: "", deviceToken: "", connectedID: "")
        
        guard let token = credential.identityToken else { return }
        guard let tokenString = String(data: token, encoding: .utf8) else { return }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)

        Auth.auth().signIn(with: firebaseCredential) { result, error in
            if let error = error, result != nil {
                print(error)
                return
            }
            guard let user = result?.user else { return }
            let document = Firestore.firestore().collection("User").document(user.uid)
            document.getDocument { document, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let document = document, document.exists {
                    self.path.append(.mainView)
                } else {
                    self.fetchUserDataFromApple(credential: credential)
                    self.path.append(.nicknameView)
                    do {
                        let userInfo = User(name: "", nickname: "", dDay: "", userID: user.uid, email: user.email ?? "", deviceToken: "", connectedID: "")
                        try Firestore.firestore().collection("User").document(user.uid).setData(from: userInfo)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
    
    func fetchUserDataFromApple(credential: ASAuthorizationAppleIDCredential) {
        guard let givenName = credential.fullName?.givenName else { return }
        self.updateUserModel(user: User(name: givenName, nickname: "", dDay: "", userID: "", email: credential.email ?? "", deviceToken: "", connectedID: ""))
    }
    

    
    func addUserToFirestore() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        setUserId(uid: currentUser.uid)
        setUserDeviceToken(deviceToken: Messaging.messaging().fcmToken!)
        
        self.path.append(.coupleCodeView)
        
        do {
            let _ = try Firestore.firestore().collection("User").document(user.userID)
                .setData(from: self.user)
                
        } catch {
            print(error)
        }
    }
    
    func setUserNickname(nickname: String) {
        self.user.nickname = nickname
    }
    
    func setUserId(uid: String) {
        self.user.userID = uid
    }
    
    func setUserDeviceToken(deviceToken: String) {
        self.user.deviceToken = deviceToken
    }
    
    func createUserInAuth(email: String, userName: String, password: Int64, profileImage: URL) {
        let passwordToString = String(describing: password)
        Auth.auth().createUser(withEmail: email, password: passwordToString) { result, error in
            if let error = error {
                print(error)
                return
            }
            
            self.login(email: email, password: passwordToString)
        }
    }

    func connectUsertoUser(to loverUid: String) {
        let db = Firestore.firestore()
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").document(loverUid).getDocument { document, error in
            if let error = error {
                print(error)
                return
            }
            
            let currentUserData = db.collection("User").document(currentUserUid)    
            let _ = currentUserData.updateData(["connectedID": loverUid])
            
            let loverUserData = db.collection("User").document(loverUid)
            let _ = currentUserData.addSnapshotListener { snapshot, error in
                if let _ = error {
                    return
                }
                if let _ = snapshot?.exists {
                    let _ = loverUserData.updateData(["connectedID": currentUserUid])
                }
                
                self.path.append(.successView)
            }
        }
    }
    
    private func login(email: String, password: String) {
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

    private func checkIfUserAlreadyRegistered(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { result, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                let isUserRegistered = result != nil && !result!.isEmpty
                completion(isUserRegistered)
            }
        }
    }
    
    // 로그인했는데, 닉네임 안정하고 껐을 때
    func checkIfUserSetNickname(email: String, completion: @escaping (Bool) -> Void) {
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
