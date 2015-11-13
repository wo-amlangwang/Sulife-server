//
//  MapVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/15/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate {
    
    var coreLocationManager = CLLocationManager()
    
    var locationManager:LocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreLocationManager.delegate = self
        
        locationManager = LocationManager.sharedInstance
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector("requestAlwaysAuthorization") || coreLocationManager.respondsToSelector("requestWhenInUseAuthorization"){
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil {
                coreLocationManager.requestAlwaysAuthorization()
                getLocation()
            }else{
                print("No descirption provided")
            }
        }else{
            print("INNN")
            getLocation()
        }
        
        // Lawson pin
        var latitude1:CLLocationDegrees = 40.4277951
        var longitude1:CLLocationDegrees = -86.9169992
        
        var lawsonLocation1:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude1, longitude1)
        
        var lawsonAnnotation1 = MKPointAnnotation()
        
        lawsonAnnotation1.coordinate = lawsonLocation1
        
        lawsonAnnotation1.title = "CS252--Lawson, Department of Computer Science"
        lawsonAnnotation1.subtitle = "coding lab5 server"
        self.mapView.addAnnotation(lawsonAnnotation1)
        
        // walmart pin
        var latitude2:CLLocationDegrees = 40.4571468
        var longitude2:CLLocationDegrees = -86.9324773
        
        var lawsonLocation2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude2, longitude2)
        
        var lawsonAnnotation2 = MKPointAnnotation()
        
        lawsonAnnotation2.coordinate = lawsonLocation2
        
        lawsonAnnotation2.title = "Shopping--Walmart"
        lawsonAnnotation2.subtitle = "shopping test"
        self.mapView.addAnnotation(lawsonAnnotation2)
        
        // football pin
        var latitude3:CLLocationDegrees = 40.4344906
        var longitude3:CLLocationDegrees = -86.9184001
        
        var lawsonLocation3:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude3, longitude3)
        
        var lawsonAnnotation3 = MKPointAnnotation()
        
        lawsonAnnotation3.coordinate = lawsonLocation3
        
        lawsonAnnotation3.title = "Football Game--Ross-Ade Stadium"
        lawsonAnnotation3.subtitle = "football test"
        self.mapView.addAnnotation(lawsonAnnotation3)
        
        
    }
    
    func getLocation(){
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        }
        
    }
    
    func displayLocation(location:CLLocation){
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
            
            let address = reverseGecodeInfo?.objectForKey("formattedAddress") as! String
            print(address)
            
        })
        
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted{
            getLocation()
        }
    }
    
    
    @IBAction func updateLocation(sender: AnyObject) {
        getLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
