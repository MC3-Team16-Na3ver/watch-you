//
//  ButtonViewModel.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import Foundation
import Combine
import WatchKit
import WatchConnectivity

class ButtonViewModel: ObservableObject {
    @Published var isMainScreen = true  // 메인 버튼 누르기 스크린 여부 확인
    
    @Published var longPressDetected = false    // 오래 누른 상태 확인
    @Published var isLoading = false        // 전송 로딩
    
    @Published var progress: Double = 0.0       // 프로그래스 바 값
    @Published var isProgressComplete = false   // 프로그래스 바 채워졌는지 여부
    @Published var isSendComplete = false       // 알림 전송 성공 여부
    
    @Published var maxHearts: Int = 5      // 전체 하트 개수
    
    @Published var isTimerRunning = false   // 타이머 실행 여부
    @Published var remainingTime = 1 * 60  // 30분 설정
    
    let watchDataController = WatchDataController.shared
    
    var timerText: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var remainingHearts: Int {
        get {
            return watchDataController.loadRemainingHearts()
        }
        set {
            watchDataController.saveRemainingHearts(newValue)
        }
    }
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var backgroundTask: WKWatchConnectivityRefreshBackgroundTask?
    
    init() {
        // 백그라운드 작업을 관리하기 위한 Observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidEnterBackground(_:)), name: WKExtension.applicationDidEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillEnterForeground(_:)), name: WKExtension.applicationWillEnterForegroundNotification, object: nil)
        
        // 앱 시작 시 타이머를 초기화합니다.
        startTimer()
    }
    
    deinit {
        // Observer 해제
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleApplicationDidEnterBackground(_ notification: Notification) {
        // 앱이 백그라운드로 들어갈 때, 타이머 상태를 저장
        UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
        UserDefaults.standard.set(isTimerRunning, forKey: "isTimerRunning")
        
        // 백그라운드 업데이트 요청
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(), userInfo: nil) { error in
            if let error = error {
                print("백그라운드 업데이트 요청 중 에러: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func handleApplicationWillEnterForeground(_ notification: Notification) {
        // 앱이 다시 활성화될 때, 타이머 상태를 복원
        if let savedRemainingTime = UserDefaults.standard.value(forKey: "remainingTime") as? Int,
           let savedIsTimerRunning = UserDefaults.standard.value(forKey: "isTimerRunning") as? Bool {
            remainingTime = savedRemainingTime
            isTimerRunning = savedIsTimerRunning
        }
        
        // 앱이 완전히 종료되었고 타이머가 실행 중이면 타이머를 다시 시작
        if !isTimerRunning && WKExtension.shared().applicationState == .active {
            startTimer()
        }
    }
    
    private func scheduleBackgroundTimer() {
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
                    timer.invalidate()
                    // 타이머 종료
                }
                self.remainingTime = 1 * 60
            }
        })
    }
    
    func startTimer() {
        // 타이머 시작
        guard !isTimerRunning else { return }
        isTimerRunning = true
        
        // 백그라운드 타이머도 시작
        scheduleBackgroundTimer()
    }
    
    /// progressBar가 다 완료되기 전에 손을 뗄 경우 해당 함수 호출
    func handsOffBeforeProgressComplete() {
        self.longPressDetected = false
    }
    
    /// progressBar 진행
    func startProgressAnimation() {
        if self.longPressDetected == true { return }
        
        self.longPressDetected = true
        self.isMainScreen = false
        
        let incrementValue: Double = 0.01
        let totalTime: Double = 2  // 임시 설정 값 (예시 2초동안 누르고 있어야 함)
        let totalSteps = totalTime / incrementValue
        var currentStep: Double = 0
        
        Timer.scheduledTimer(withTimeInterval: incrementValue, repeats: true) { timer in
            
            if self.longPressDetected == false {
                timer.invalidate()
                self.isMainScreen = true
                return
            }
            
            currentStep += 1
            if currentStep >= totalSteps {
                self.finishAnimation()
                timer.invalidate()
                return
            }
            
            self.progress = currentStep / totalSteps
        }
    }
    
    func finishAnimation() {
        self.isProgressComplete = true
        self.longPressDetected = false
    }
    
    func finishSend() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.remainingHearts -= 1    // 하트 개수 감소
            self.isProgressComplete = false
            self.isMainScreen = true
        }
    }
    
    /// 로딩중일 때 - Notification 전송 시도
    func sendPeerToNotification() {
        self.isLoading = true
        self.isMainScreen = false
        
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
}
