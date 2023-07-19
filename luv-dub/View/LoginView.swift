//
//  LoginView.swift
//  LoveDuk
//
//  Created by Song Jihyuk on 2023/07/11.
//

import AuthenticationServices
import FirebaseAuth
import SwiftUI


enum ViewType {
    case nicknameView
    case coupleCodeView
    case invitationView
    case successView
    case mainView
    
}

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack(path: $loginViewModel.path) {
                VStack {
                    appleLoginButton
                    kakaoLoginButton
                }
                .navigationDestination(for: ViewType.self, destination: { viewType in
                    switch viewType {
                    case .nicknameView:
                        NicknameSetView()
                    case .coupleCodeView:
                        CoupleCodeView()
                    case .invitationView:
                        InvitationView()
                    case .mainView:
                        MainView()
                    case .successView:
                        SuccessView()
                    }
                    
                })
                .padding(.horizontal, 16)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private var appleLoginButton: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
            request.nonce = loginViewModel.cryptoUserData()
            
        } onCompletion: { result in
            switch result {
            case .success(let authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    loginViewModel.signInWithApple(credential: appleIDCredential)

                default:
                    break
                }
                
            case .failure(let authResults):
                print("fail \(authResults)")
            }
        }
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
    }
    
    private var kakaoLoginButton: some View {
        Button {
            loginViewModel.signInWithKakao()
        } label: {
            Image("KakaotalkButton")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
