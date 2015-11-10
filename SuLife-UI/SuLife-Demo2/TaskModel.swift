//
//  EventModel.swift
//  SuLife-Demo2
//
//  Created by Qi Zhang on 11/8/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class TaskModel: NSObject {
    var title : NSString
    var detail : NSString
    var taskTime : NSDate
    var id : NSString
    var share : Bool
    
    init (title : NSString, detail : NSString, time : NSDate, id : NSString, share : Bool) {
        self.title = title
        self.detail = detail
        self.taskTime = time
        self.id = id
        self.share = share
    }
}
