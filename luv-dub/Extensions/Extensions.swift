//
//  Extensions.swift
//  luv-dub
//
//  Created by moon on 2023/07/30.
//

import Foundation
import FirebaseAuth

extension Auth {
    func subStrUid() -> String {
        // uid 대입
        var ret: String = self.currentUser?.uid ?? "잘못된 초대코드입니다"
        // 앞6자리 자르기
        ret = ret.substring(from: 0, to: 5)
        // 소문자로 만들기
        return ret.lowercased()
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
          
          // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
