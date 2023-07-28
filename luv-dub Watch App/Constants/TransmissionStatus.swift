//
//  TransmissionStatus.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/26.
//

import Foundation

enum TransmissionStatus: String, CustomStringConvertible {
    case inProgress, sendComplete, sendFail
    
    var status: String {
        switch self {
        case .inProgress:
            return "전송중"
        case .sendComplete:
            return "전송 완료"
        case .sendFail:
            return "전송 실패"
        }
    }
    
    var description: String {
        switch self {
        case .inProgress:
            return "상대방에게 \n 나의 마음을 보내는 중이에요"
        case .sendComplete:
            return "상대방에게 \n 나의 마음을 보냈어요"
        case .sendFail:
            return "알림 전송이 실패했습니다 \n 다시 시도해 주세요"
        }
    }
}
