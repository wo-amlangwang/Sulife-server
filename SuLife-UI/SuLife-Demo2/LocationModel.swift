//
//  ContactsModel.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit
import MapKit

class LocationModel: NSObject {
    
    var placeName : String
    var coordinate: CLLocationCoordinate2D
    // var id : NSString
    
    init (placeName : String, coordinate: CLLocationCoordinate2D) {
        self.placeName = placeName
        self.coordinate = coordinate
        //self.id = id
    }
    
    
}
