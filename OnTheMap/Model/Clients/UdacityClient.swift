//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 22.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    var uniqueKey: String!
    
    var udacityAccount: UdacityAccount!
    
    func postSession(username: String, password: String, completionHandler: @escaping(_ result: String?, _ error: String?) -> Void) {
        
        func sendError(_ error: String) {
            print(error)
            completionHandler(nil, error)
        }
        
        var request = prepareUdacityRequest(url: "https://www.udacity.com/api/session")
        request.httpMethod = "POST"
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        print(String(data: request.httpBody!, encoding: .utf8)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil { // Handle error…
                if let error = error as NSError? {
                    if (error.code == CFNetworkErrors.cfurlErrorTimedOut.rawValue || error.code == CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue || error.code == CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue) {
                        sendError("Please check your internet connection")
                    } else {
                        sendError(error.localizedDescription)
                    }
                    
                    return
                } else {
                    
                    sendError(error!.localizedDescription)
                    return
                }
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                do {
                    let parsedError = try JSONSerialization.jsonObject(with: self.clearUdacityResponse(data: data!), options: .allowFragments) as! [String:AnyObject]
                    
                    let error = parsedError["error"] as! String
                    
                    sendError(error)
                    
                } catch {
                    sendError("There is a problem with connection")
                }
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: self.clearUdacityResponse(data: data), options: .allowFragments) as! [String:AnyObject]
                
            } catch {
                sendError("There is a problem with connection")
                return
            }
            
            guard var session = parsedResult["session"] as! [String:AnyObject]! else {
                sendError("Cannot login, session")
                return
            }
            
            guard let sessionId = session["id"] as! String! else {
                sendError("Cannot login, sessionID")
                return
            }
            
            guard var account = parsedResult["account"] as! [String:AnyObject]! else {
                sendError("Cannot login, account")
                return
            }
            
            guard let key = account["key"] as! String! else {
                sendError("Account Error")
                return
            }
            
            print(key)
            
            self.getUdacityUser(userId: key)
            
            self.uniqueKey = key
            
            completionHandler(sessionId, nil)
            
        }
        task.resume()
        
    }
    
    func deleteSession(completionHandler: @escaping(_ result: String?, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
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
            if error != nil { // Handle error…
                
                print(error?.localizedDescription)
                
                completionHandler(nil, "Logout failed")
                
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, "Logout failed")
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            completionHandler("Logout", nil)
            
        }
        task.resume()
        
    }
    
    func getUdacityUser(userId: String) {
        
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/" + userId)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let parsedResult = self.extractJSON(data: data!)
            
            guard parsedResult != nil else {
                print("parsedResult nil")
                return
            }
            
            guard let user = parsedResult!["user"] as! [String:AnyObject]! else {
                
                print("parse error")
                return
            }
            
            let firstName = user["first_name"] as! String
            let lastName = user["last_name"] as! String
            let key = user["key"] as! String
            
            let udacityAccount = UdacityAccount(key: key, firstName: firstName, lastName: lastName)
            
            self.udacityAccount = udacityAccount
            
            print("\(self.udacityAccount)")
            
        }
        task.resume()
        
    }
    
    func extractJSON(data: Data) -> [String:AnyObject]? {
        var parsedResult: [String:AnyObject]!
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: self.clearUdacityResponse(data: data), options: .allowFragments) as! [String:AnyObject]
            
        } catch {
            
            return nil
        }
        
        return parsedResult
    }
    
    func prepareUdacityRequest(url: String) -> URLRequest {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func clearUdacityResponse(data: Data) -> Data {
        
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        
        return newData
    }
    
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}
