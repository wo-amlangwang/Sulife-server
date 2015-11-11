//
//  EventModel.swift
//  SuLife-Demo2
//
//  Created by Qi Zhang on 11/8/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    var firstName : NSString
    var lastName : NSString
    var email : NSString
    var id : NSString
    
    init (firstName : NSString, lastName : NSString, email : NSString, id : NSString) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
    }
}
