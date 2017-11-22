//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 22.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    
    func postSession(username: String, password: String, completionHandler: @escaping(_ result: String?, _ error: String?) -> Void) {
        
        func sendError(_ error: String) {
            print(error)
            completionHandler(nil, error)
        }
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        var session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
           
            if error != nil { // Handle error…
                sendError("There was an error with your request: \(error!)")
                return
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
                sendError("Cannot login session")
                return
            }
            
            guard let sessionId = session["id"] as! String! else {
                sendError("Cannot login sessionID")
                return
            }
            
            completionHandler(sessionId, nil)
            
        }
        task.resume()
        
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
