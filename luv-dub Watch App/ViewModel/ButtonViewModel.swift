//
//  ButtonViewModel.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import Foundation

class ButtonViewModel: ObservableObject {
    @Published var tapStatus = ""
    @Published var isClicked = false
    @Published var longPressDetected = false
    @Published var isLoading = false
    
    
    /// Button의 longPress가 감지됐을 때 처리하는 함수
    ///  값을 원상태로 돌린다.
    func handleLongPressedDetected() {
        if longPressDetected {
            tapStatus = "Tap Done"
            isClicked = false
            longPressDetected = false
        } else {
            tapStatus = "Please Press and hold"
        }
    }
    
    
    
    /// Button의 longPressGesture가 trigger 됐을 때 처리하는 함수
    func handleLongPressEnded() {
        if !isClicked {
            tapStatus = "Tap Currently Holded"
            isClicked = true
            longPressDetected = true
        }
    }
    
    /// 상태값 확인을 위한 출력 함수
    func printStatus() {
        print("tapStatus: \(tapStatus)")
        print("isClicked: \(isClicked)")
        print("longPressDetected: \(longPressDetected)")
        print("isLoading: \(isLoading)")
    }
}
