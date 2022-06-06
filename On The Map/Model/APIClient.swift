//
//  APIClient.swift
//  On The Map
//
//  Created by Jia Li on 6/5/22.
//

import Foundation

class APIClient {
    struct Auth {
        static var accountKey = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        static let session = "session"
        
        case login
        case logout
        
        var stringValue: String {
            switch self {
                case .login: return Endpoints.base + Endpoints.session
                case .logout: return Endpoints.base + Endpoints.session
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: Login
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let udacityDetail = Udacity(username: username, password: password)
        let body = LoginRequest(udacity: udacityDetail)
        var request = URLRequest(url: APIClient.Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            // Skip the first 5 characters of the response
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.Auth.sessionId = responseObject.session.id
                    self.Auth.accountKey = responseObject.account.key
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    
}
