//
//  StudentLocationResponse.swift
//  On The Map
//
//  Created by Jia Li on 6/6/22.
//

import Foundation

struct StudentInformationResponse: Codable {
    let studentInformationResults: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case studentInformationResults = "results"
    }
}

struct StudentInformation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
}
