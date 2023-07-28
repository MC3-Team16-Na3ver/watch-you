//
//  ProgressViewModel.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import Foundation

class ProgressViewModel: ObservableObject {
    @Published var progress: CGFloat = 0.0
    @Published var isComplete = false
    @Published var isPulsing = false

    private var timer: Timer?
    private var totalTime: TimeInterval = 3.0 // 총 누르는 시간 (3초라 임시 가정)

    /// 프로그래스바 진행 시작
    func startProgressAnimation() {
        progress = 0.0 // 상태 초기화
        isComplete = false
        isPulsing = true // 애니메이션 활성화

        // Timer를 활용하여 0.1 만큼 증가
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            self.progress += 0.1 / CGFloat(self.totalTime)

            if self.progress >= 1.0 {
                timer.invalidate()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isComplete = true // 진행 완료 표시
                    self.isPulsing = false // 애니메이션 비활성화
                }
            }
        }
    }

    /// 프로그래스 바 진행 종료
    func stopProgressAnimation() {
        timer?.invalidate()
        progress = 0.0
        isComplete = false
        isPulsing = false // 애니메이션 비활성화
    }
}


//class ProgressViewModel: ObservableObject {
//    @Published var progress: CGFloat = 0.0
//    @Published var isComplete = false
//    @Published var isPulsing = false
//
//
//    private var timer: Timer?
//    private var totalTime: TimeInterval = 3.0  // 총 누르는 시간 (3초라 임시 가정)
//
//
//
//    /// 프로그래스바 진행 시작
//    func startProgressAnimation() {
//        progress = 0.0 // 상태 초기화
//        isComplete = false
//        isPulsing = true // 애니메이션 활성화
//
//        // Timer를 활용하여 0.1 만큼 증가
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
//            guard let self = self else {
//                timer.invalidate()
//                return
//            }
//
//            self.progress += 0.1 / CGFloat(self.totalTime)
//
//            if self.progress >= 1.0 {
//                timer.invalidate()
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.isComplete = false
//                    self.progress = 0.0
//                    self.isPulsing = false // 애니메이션 비활성화
//                }
//            }
//        }
//    }
//
//    /// 프로그래스 바 진행 종료
//    func stopProgressAnimation() {
//        timer?.invalidate()
//        progress = 0.0
//        isComplete = false
//        isPulsing = false // 애니메이션 비활성화
//    }
//}
