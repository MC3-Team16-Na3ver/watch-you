//
//  OnboardingView.swift
//  LoveDuk
//
//  Created by Song Jihyuk on 2023/07/11.
//

import FirebaseAuth
import SwiftUI

struct NicknameSetView: View {
    @State private var nickname: String = ""
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
            nicknameSetView
            .padding(.horizontal, 16)
            .padding(.top, 150)
    }
    
    private var nicknameSetView: some View {
        VStack(alignment: .leading, spacing: 6) {
            TextField("닉네임을 입력해주세요", text: $nickname)
                .frame(maxWidth: .infinity)
            Rectangle()
                .fill(.red)
                .frame(height: 1)
            
            Spacer()
            
            Button {
                loginViewModel.user.nickname = self.nickname
                loginViewModel.addUserToDatabase()
                loginViewModel.path.append(.coupleCodeView)
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .overlay(
                        Text("다음")
                            .foregroundColor(.white))
                
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameSetView()
    }
}
