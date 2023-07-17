//
//  luv_dubApp.swift
//  luv-dub
//
//  Created by 김예림 on 2023/07/12.
//

import Firebase
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI



@main
struct luv_dubApp: App {
    
    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
