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
        static let studentLocation = "StudentLocation"
        static let users = "users/"
        
        case login
        case logout
        case getPinnedLocations
        case postStudentLocation
        case getUserData
        
        var stringValue: String {
            switch self {
                case .login: return Endpoints.base + Endpoints.session
                case .logout: return Endpoints.base + Endpoints.session
                case .getPinnedLocations: return Endpoints.base + Endpoints.studentLocation
                + "?limit=100&order=-updatedAt"
                case .postStudentLocation: return Endpoints.base + Endpoints.studentLocation
                case .getUserData: return Endpoints.base + Endpoints.users + Auth.accountKey
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: Login Network call
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
    
    // MARK: Get Pinned Locations Network call
    class func getPinnedLocations(completion: @escaping ([PinnedLocation]?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getPinnedLocations.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.locations, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: Logout Network Call
    class func logout(completion: @escaping() -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
              print(error?.localizedDescription ?? "")
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
          completion()
        }
        task.resume()
    }
    
    // MARK: Get User Data Network Call
    class func getUserData(completion: @escaping (UserDataResponse?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getUserData.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            do {
                let responseObject = try decoder.decode(UserDataResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    // MARK: Post Location Network Call
    class func postStudentLocation(postRequest: PostStudentLocationRequest, completion: @escaping (PostStudentLocationResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = postRequest
        request.httpBody = try! JSONEncoder().encode(body)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostStudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
}
