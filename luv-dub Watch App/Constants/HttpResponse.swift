//
//  HttpResponse.swift
//  luv-dub Watch App
//
//  Created by moon on 2023/09/16.
//

import Foundation

struct HttpResponse: Codable {
    let status_code: Int
    let body: String
}
