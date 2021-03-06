//
//  StudentInformationList.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 24.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation

class StudentInformations {
    
    let dataModelDidUpdateNotification = "studentInformationsDidUpdateNotification"
    
    
    private (set) var data : [StudentInformation]? {
        
        didSet {
            NotificationCenter.default.post(name:
                NSNotification.Name(rawValue: dataModelDidUpdateNotification), object: nil)        }
        
    }
    
    static var sharedInstance = StudentInformations()
    
    private init(){
        
    }
    
    func requestData(completionHandler: @escaping(_ result: [StudentInformation]?, _ error: String?) -> Void) {
        ParseClient.sharedInstance().getStudentLocations(completionHandler: { result, error in
            
            guard  error == nil else {
                
                completionHandler(nil, error)
                
                return
            }
            
            self.data = result!
            
            completionHandler(result, nil)

            
        })
        
    }    
    
}

