//
//  LoginResponse.swift
//  On The Map
//
//  Created by Jia Li on 6/5/22.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
