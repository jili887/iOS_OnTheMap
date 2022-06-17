//
//  UserDataResponse.swift
//  On The Map
//
//  Created by Jia Li on 6/14/22.
//

import Foundation

struct UserDataResponse: Codable {
    let firstName: String
    let lastName: String
    let accountKey: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case accountKey = "key"
    }
}
