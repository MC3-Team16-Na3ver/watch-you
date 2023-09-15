//
//  luv_dubApp.swift
//  luv-dub
//
//  Created by 김예림 on 2023/07/12.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI
import UserNotifications
import WatchConnectivity

@main
struct luv_dubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var dataController = DataController()
    
    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(LoginViewModel())
                .environmentObject(AppDelegate())
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {


    @Published var isAlertOn: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
    
        Messaging.messaging().delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        checkNotificationPermission()
        requestNotificationPermission()
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo:", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken deviceToken: String?) {
        
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("User").document(userUid)
            .updateData(["deviceToken": deviceToken ])
    }
}
