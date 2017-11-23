//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Gokturk Ramazanoglu on 22.11.17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation

struct StudentInformation  {
    
    var createdAt:String?
    var firstName:String?
    var lastName:String?
    var latitude:Double?
    var longitude:Double?
    var mapString:String?
    var mediaUrl:String?
    var objectID:String?
    var uniqueKey:String?
    var updatedAt:String?
    
    
    init(dictionary : [String: AnyObject]) {
        self.createdAt = dictionary["createdAt"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.mapString = dictionary["mapString"] as? String
        self.mediaUrl = dictionary["mediaURL"] as? String
        self.objectID = dictionary["objectId"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String
        self.updatedAt = dictionary["updatedAt"] as? String
        
    }
    
}
