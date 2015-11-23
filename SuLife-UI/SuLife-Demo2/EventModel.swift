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
    var id : NSString
    var share : Bool
    var lng : NSNumber
    var lat : NSNumber
    var locationName : NSString
    
    init (title : NSString, detail : NSString, startTime : NSDate, endTime : NSDate, id : NSString, share : Bool, lng : NSNumber, lat : NSNumber, locationName : NSString) {
        self.title = title
        self.detail = detail
        self.startTime = startTime
        self.endTime = endTime
        self.id = id
        self.share = share
        self.lng = lng
        self.lat = lat
        self.locationName = locationName
    }
}
