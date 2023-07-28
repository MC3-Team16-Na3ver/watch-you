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
            } else {
                LoginView()
                    .onAppear {
                        loginViewModel.path.append(.mainView)
                    }
            }
        }
        .padding()
    }
}
