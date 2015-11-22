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
    var finish : Bool
    var id : NSString
    
    init (title : NSString, detail : NSString, time : NSDate, finish : Bool, id : NSString) {
        self.title = title
        self.detail = detail
        self.taskTime = time
        self.finish = finish
        self.id = id
    }
}
