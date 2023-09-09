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
    let gcmMessageIDKey = "gcm.message_id"
    let aps = "aps"
    let data1Key = "DATA1"
    let data2Key = "DATA2"


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
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("userInfo:", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let data1 = userInfo[data1Key] {
            print("data1: \(data1)")
        }
        
        if let data2 = userInfo[data1Key] {
            print("data1: \(data2)")
        }
        
        if let apsData = userInfo[aps] {
            print("apsData: \(apsData)")
        }
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from usernotificationCenter didReceive: \(messageID)")
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("messaging")
        
        let deviceToken: [String:String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken)
        
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("User").document(userUid)
            .updateData(["deviceToken": fcmToken ?? ""])
        
        print("deviceToken updated")

    }
}
