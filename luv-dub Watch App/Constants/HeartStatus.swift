//
//  HeartStatus.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/27.
//

import Foundation

enum HeartStatus: String {
    case isFull, runTimer
    
    var status: String {
        switch self {
        case .isFull:
            return "FULL"
        case .runTimer:
            return "29:59"
        }
    }
}
