//
//  User.swift
//  luv-dub
//
//  Created by Song Jihyuk on 2023/07/12.
//

import SwiftUI

struct User: Codable, Identifiable, Hashable {
    let name: String
    var nickName: String
    let dDay: String
    var userID: String
    let email: String
    var id: String {
        userID
    }
}
