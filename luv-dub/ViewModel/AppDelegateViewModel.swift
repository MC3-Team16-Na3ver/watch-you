//
//  SystemViewModel.swift
//  luv-dub
//
//  Created by moon on 2023/07/28.
//

import SwiftUI

extension AppDelegate: ObservableObject {
    
    // 앱의 알림권한을 확인하는 함수
    func checkNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings{ settings in
            if settings.alertSetting == .enabled {
                self.isAlertOn = true
            } else {
                self.isAlertOn = false
            }
        }
    }
    
    
    // 앱의 설정화면으로 이동하기
    func moveNotificationSetting() {
        DispatchQueue.main.async{
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    // 알림권한을 요청하는창을 띄운다
    // 앱을 설치한 후 단 한 번만 요청할 수 있다
    func requestNotificationPermission(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted , error in }
    }
}
