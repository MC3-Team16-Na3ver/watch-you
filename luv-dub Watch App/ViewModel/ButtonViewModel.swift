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
    
    @Published var showProgressBar = false
    @Published var progress: Double = 0.0
    @Published var isProgressComplete = false
    
    /// Button의 longPress가 감지됐을 때 처리하는 함수
    /// 값을 원상태로 돌린다.
    func handleLongPressedDetected() {
        if longPressDetected {
            tapStatus = "Tap Done"
            isClicked = false
            longPressDetected = false
            showProgressBar = false // 프로그래스 바 초기화
            progress = 0.0
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
            showProgressBar = true // 프로그래스 바 보이기
            startProgressAnimation()
        }
    }
    
    /// 상태값 확인을 위한 출력 함수
    func printStatus() {
//        print("tapStatus: \(tapStatus)")
//        print("isClicked: \(isClicked)")
//        print("longPressDetected: \(longPressDetected)")
//        print("isLoading: \(isLoading)")
        print("isComplete: \(isProgressComplete)")
    }
    
    /// progressBar 진행
    private func startProgressAnimation() {
        let incrementValue: Double = 0.01
        let totalTime: Double = 2  // 임시 설정 값 (예시 2초동안 누르고 있어야 함)
        let totalSteps = totalTime / incrementValue
        var currentStep: Double = 0
        
        Timer.scheduledTimer(withTimeInterval: incrementValue, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            currentStep += 1
            
            if currentStep >= totalSteps {
                timer.invalidate()
                self.handleLongPressedDetected()
                self.isProgressComplete = true
                return
            }
            
            // UI 업데이트를 메인 스레드에서 수행
            DispatchQueue.main.async {
                self.progress = currentStep / totalSteps
            }
        }
    }
    
    /// ProgressBar reset 함수
    func resetProgress() {
        isProgressComplete = false
        showProgressBar = false
        progress = 0.0
    }

}
