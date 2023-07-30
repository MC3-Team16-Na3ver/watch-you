//
//  ButtonViewModel.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import Foundation
import Combine

class ButtonViewModel: ObservableObject {
    @Published var isMainScreen = true  // 메인 버튼 누르기 스크린 여부 확인
    
    @Published var longPressDetected = false    // 오래 누른 상태 확인
    @Published var isLoading = false        // 전송 로딩
    
    @Published var progress: Double = 0.0       // 프로그래스 바 값
    @Published var isProgressComplete = false   // 프로그래스 바 채워졌는지 여부
    @Published var isSendComplete = false       // 알림 전송 성공 여부
    
    @Published var maxHearts: Int = 5      // 전체 하트 개수
    @Published private(set) var remainingHearts: Int = 5    // 남은 하트 개수
    
    @Published var isTimerRunning = false   // 타이머 실행 여부
    @Published var remainingTime = 1 * 60  // 30분 설정
    
    var timerText: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    
    /// progressBar 진행
    func startProgressAnimation() {
        if longPressDetected == true { return }
        
        longPressDetected = true
        
        let incrementValue: Double = 0.01
        let totalTime: Double = 2  // 임시 설정 값 (예시 2초동안 누르고 있어야 함)
        let totalSteps = totalTime / incrementValue
        var currentStep: Double = 0
        
        Timer.scheduledTimer(withTimeInterval: incrementValue, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if longPressDetected == false {
                timer.invalidate()
                return
            }
            
            currentStep += 1
            
            if currentStep >= totalSteps {
                timer.invalidate()
                self.isProgressComplete = true
                self.longPressDetected = false
                return
            }
            
            self.progress = currentStep / totalSteps
        }
    }
    /// 로딩중일 때 - Notification 전송 시도
    func sendPeerToNotification() {
        isLoading = true
        
        // 서버에 알림 보내는 로직 추가하면 됩니다.
        // 테스트 가정 케이스 -> UI 확인을 위한 임시 코드입니다. (실제 코드로 대체 필요)
        // 1. 성공했다고 가정 시
        Just(true)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)  // 2초 후에 완료
            .sink { [weak self] isSuccess in
                self?.isLoading = false
                if isSuccess {
                    // 알림 전송 성공
                    self?.isSendComplete = true
                    self?.remainingHearts -= 1    // 하트 개수 감소 
                    // 성공 콜백 함수 호출
                } else {
                    // 알림 전송 실패
                    self?.isSendComplete = false
                    // 실패 콜백 함수 호출
                }
            }
            .store(in: &cancellables)
    }
    
    /// 타이머 실행 함수
    func startTimer() {
        guard !isTimerRunning else { return }
        isTimerRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                if self.remainingHearts < self.maxHearts {
                    self.remainingHearts += 1
                } else {
                    self.isTimerRunning = false
                    timer.invalidate()
                }
                self.remainingTime = 1 * 60
                self.isTimerRunning = false
            }
        })
    }
    
    /// Notification 전송 시도가 완료됐을 때 호출하는 함수
//    func stopLoading() {
//        self?.isLoading = false
//    }
}
