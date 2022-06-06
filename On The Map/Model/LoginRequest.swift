//
//  LoginRequest.swift
//  On The Map
//
//  Created by Jia Li on 6/5/22.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
}

struct Udacity: Codable {
    let username: String
    let password: String
}
