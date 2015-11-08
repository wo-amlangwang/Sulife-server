//
//  EventModel.swift
//  SuLife-Demo2
//
//  Created by Qi Zhang on 11/8/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class EventModel: NSObject {
    var title : NSString
    var detail : NSString
    var startTime : NSDate
    var endTime : NSDate
    
    init (title : NSString, detail : NSString, startTime : NSDate, endTime : NSDate) {
        self.title = title
        self.detail = detail
        self.startTime = startTime
        self.endTime = endTime
    }
}
