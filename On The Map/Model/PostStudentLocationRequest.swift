//
//  PostStudentLocationRequest.swift
//  On The Map
//
//  Created by Jia Li on 6/14/22.
//

import Foundation

struct PostStudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
