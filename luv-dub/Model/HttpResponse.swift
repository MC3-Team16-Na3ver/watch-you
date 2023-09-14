//
//  HttpResult.swift
//  luv-dub
//
//  Created by moon on 2023/09/14.
//

import Foundation

struct HttpResponse: Codable {
    let status_code: Int
    let body: String
}
