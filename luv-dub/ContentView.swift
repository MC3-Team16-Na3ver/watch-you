//
//  ContentView.swift
//  luv-dub
//
//  Created by 김예림 on 2023/07/12.
//

import CoreData
import Firebase
import FirebaseAuth
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<UserInfo>
    
    var body: some View {
        VStack {
            if users.isEmpty {
                LoginView()
            }
            
            else if isUserHasLover() {
                LoginView()
                    .onAppear {
                        loginViewModel.path.append(.mainView)
                    }
            }
            
            else if isUserHasNickname() {
                LoginView()
                    .onAppear {
                        loginViewModel.path.append(.coupleCodeView)
                    }
            }
        }
        .padding()
    }
    
    private func isUserHasNickname() -> Bool {
        if let _ = users.last!.nickname {
            return true
        }
        return false
    }
    
    private func isUserHasLover() -> Bool {
        if let _ = users.last!.connectedID {
            return true
        }
        return false
    }
}
