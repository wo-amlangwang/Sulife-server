//
//  EventsManager.swift
//  SuLife
//
//  Created by Sine Feng on 10/16/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

var eventMgr: EventManager = EventManager()

struct event {
    var name = "Un-Named"
    var desc = "Un-Described"
}

class EventManager: NSObject {
    
    var events = [event]()
    
    func addEvent(name: String, desc: String) {
        events.append(event(name: name, desc: desc))
    }
}
