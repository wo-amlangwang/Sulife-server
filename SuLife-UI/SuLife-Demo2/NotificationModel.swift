//
//  NotificationModel.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/13/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class NotificationModel: NSObject {
    
    var firstName : NSString
    var lastName : NSString
    var email : NSString
    var requestOwnerID : NSString
    var relationshipID : NSString
    var isFriend : NSNumber
    
    init (firstName : NSString, lastName : NSString, email : NSString, requestOwnerID : NSString, relationshipID : NSString, isFriend : NSNumber) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.requestOwnerID = requestOwnerID
        self.relationshipID = relationshipID
        self.isFriend = isFriend
    }

}
