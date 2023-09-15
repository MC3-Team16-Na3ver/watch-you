//
//  User.swift
//  LoveDuk
//
//  Created by Song Jihyuk on 2023/07/11.
//

import FirebaseFirestoreSwift
import SwiftUI

class User: Encodable, Decodable {
    static let shared = User()
    
    @DocumentID var id: String?
    var name: String?
    var nickname: String?
    var dDay: String?
    var userID: String?
    var email: String?
    var deviceToken: String?
    var connectedID: String?
    var invitationCode: String?
    
    
}
