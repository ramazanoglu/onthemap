//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 22.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    var loggedInStudentInformation : StudentInformation!
    
    func getStudentLocations(completionHandler: @escaping(_ result: [StudentInformation]?, _ error: String?) -> Void) {
        
        print("getStudentLocations")
        
        func sendError(_ error: String) {
            print(error)
            completionHandler(nil, error)
        }
        
        let queryItems : [String : AnyObject] = ["limit" : "100" as AnyObject,
                                                 "order" : "-updatedAt" as AnyObject]
        
        let url = createURLComponents(path: "/parse/classes/StudentLocation", queryItems: queryItems)
        
        let request = createURLRequest(url: url)
        
        runRequest(request: request, completionHandler: ({parsedResult, error in
            
            if error != nil {
                
                completionHandler(nil, error)
                
            } else {
                
                let results = parsedResult!["results"] as! [[String:AnyObject]]
                
                var studentsArray = [StudentInformation]()
                
                for result in results {
                    
                    let studentInformation = StudentInformation.init(dictionary : result)
                    
                    studentsArray.append(studentInformation)
                    
                }
                
                completionHandler(studentsArray, nil)
            }
            
        }))
        
    }
    
    func getStudentLocation(uniqueKey: String, completionHandler: @escaping(_ result: StudentInformation?, _ error: String?) -> Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/StudentLocation"
        components.queryItems = [URLQueryItem]()
        
        let queryItem1 = URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(uniqueKey)\"}")
        
        components.queryItems!.append(queryItem1)
        
        var request = URLRequest(url: components.url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        runRequest(request: request, completionHandler: ({parsedResults, error in
            
            if error != nil {
                
                completionHandler(nil, error)
                
            } else {
                
                let results = parsedResults!["results"] as! [[String:AnyObject]]
                
                var studentsArray = [StudentInformation]()
                
                for result in results {
                    
                    let studentInformation = StudentInformation.init(dictionary : result)
                    
                    studentsArray.append(studentInformation)
                    
                }
                
                if studentsArray.count > 0 {
                    completionHandler(studentsArray[0], nil)
                } else {
                    completionHandler(nil, nil)
                }
                
            }
        }))
        
    }
    
    func createStudentLocation(mapString: String, mediaURL : String, latitude:String, longitude: String, completionHandler: @escaping(_ result: Bool?, _ error: String?) -> Void){
        
        var request: URLRequest!
        
        if loggedInStudentInformation != nil {
            print("put \(loggedInStudentInformation)")
            
            let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/" + loggedInStudentInformation.objectID!
            
            let url = URL(string: urlString)
            request = createURLRequest(url: url!)
            request.httpMethod = "PUT"
            
        } else {
            print("post")
            
            request = createURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
            request.httpMethod = "POST"
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let uniqueKey = UdacityClient.sharedInstance().udacityAccount.key
        let firstName = UdacityClient.sharedInstance().udacityAccount.firstName
        let lastName = UdacityClient.sharedInstance().udacityAccount.lastName
        
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        
        runRequest(request: request, completionHandler: ({parsedResult, error in
            
            if error != nil {
                completionHandler(nil, error)
                return
            }
            
            print(parsedResult)
            
            if self.loggedInStudentInformation != nil {
                
                guard parsedResult!["updatedAt"] != nil else {
                    completionHandler(nil, "Location cannot be updated")
                    return
                }
                
                completionHandler(true, nil)

                
            } else {
                guard parsedResult!["createdAt"] != nil else {
                    completionHandler(nil, "Location cannot be created")
                    return
                }
                
                completionHandler(true, nil)
            }
                        
        }))
        
        
    }
  
    
    func runRequest(request: URLRequest, completionHandler: @escaping(_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        func sendError(_ error: String) {
            print(error)
            completionHandler(nil, error)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
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
                sendError("Cannot get data from server")
                return
            }
            
            completionHandler(parsedResult, nil)
            
            
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
