//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 22.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    func getStudentLocations(completionHandler: @escaping(_ result: String?, _ error: String?) -> Void) {
        
        func sendError(_ error: String) {
            print(error)
            completionHandler(nil, error)
        }
        
        let queryItems : [String : AnyObject] = ["limit" : "5" as AnyObject,
                                                 "order" : "-updatedAt" as AnyObject]
        
        let url = createURLComponents(path: "/parse/classes/StudentLocation", queryItems: queryItems)
        
        let request = createURLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Status Code")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                
            } catch {
                sendError("There is a problem with connection")
                return
            }
            
            let results = parsedResult["results"] as! [[String:AnyObject]]
            
            for result in results {
                
                let studentInformation = StudentLocation.init(dictionary : result)
                
                print("\(studentInformation)")
                
            }
            
            print("*************************************")
            print(parsedResult)
            
            //            completionHandler(String(data: data!, encoding: .utf8)!, nil)
        }
        task.resume()
        
    }
    
    func getStudentLocation(uniqueKey: String, completionHandler: @escaping(_ result: String?, _ error: String?) -> Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/StudentLocation"
        components.queryItems = [URLQueryItem]()
        
        let queryItem1 = URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(uniqueKey)\"}")
        
        components.queryItems!.append(queryItem1)
        
        print("\(components.url)")
        
        var request = URLRequest(url: components.url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    
    func createURLRequest(url :URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return request
    }
    
    func createURLComponents(path: String, queryItems: [String: AnyObject])  -> URL{
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = path
        components.queryItems = [URLQueryItem]()
        
        for queryItem in queryItems {
            
            components.queryItems?.append(URLQueryItem(name: queryItem.key, value: "\(queryItem.value)"))
            
        }
        return components.url!
        
    }
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
