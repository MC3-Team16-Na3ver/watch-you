//
//  User.swift
//  LoveDuk
//
//  Created by Song Jihyuk on 2023/07/11.
//

import FirebaseFirestoreSwift
import SwiftUI

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    var nickname: String
    let dDay: String
    var userID: String
    let email: String
    var deviceToken: String
    var connectedID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nickname
        case dDay
        case userID
        case email
        case deviceToken
        case connectedID
    }
    
}
