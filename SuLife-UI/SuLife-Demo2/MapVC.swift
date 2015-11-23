//
//  MapVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/15/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

// Lawson: 40.4275427,-86.9167898

import UIKit
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var initialLocation = CLLocation()
    var newCoord : CLLocationCoordinate2D!
    
    var placeNameForEvent : String?
    var coordinateForEvent: CLLocationCoordinate2D?
    
    @IBOutlet var mapView: MKMapView!
    
    var annotation:MKAnnotation!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var resArray : [NSDictionary] = []
    
    var selectEvent : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        initialLocation = locationManager.location!
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 4000, 4000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // TODO : event location
        /* get selected date */
        
        if self.mapView.annotations.count != 0{
            for annotationShouldRemove in self.mapView.annotations {
                self.mapView.removeAnnotation(annotationShouldRemove)
            }
        }
        
        let date : NSDate = dateSelected != nil ? (dateSelected?.convertedDate())! : NSDate()
        
        /* parse date to proper format */
        let sd = stringFromDate(date).componentsSeparatedByString(" ")
        let sdTime = sd[0] + " 00:01"
        let edTime = sd[0] + " 23:59"
        
        /* get data from server */
        let post:NSString = "title=&detail=&locationName=&lng=&lat=&starttime=\(sdTime)&endtime=\(edTime)"
        NSLog("PostData: %@",post);
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let url:NSURL = NSURL(string: eventByDateURL)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "post"
        request.HTTPBody = postData
        request.setValue(accountToken, forHTTPHeaderField: "x-access-token")
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            reponseError = error
            urlData = nil
        }
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            if(res == nil){
                NSLog("No Response!");
            }
            
            let responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
            
            NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                    
                    let success:NSString = jsonResult.valueForKey("message") as! NSString
        
                    if (success != "OK! Events list followed") {
                        NSLog("Get Shared Event Failed")
                    } else {
                        resArray = jsonResult.valueForKey("Events") as! [NSDictionary]
                        for event in resArray {
                            addPinToMapView(event.valueForKey("title") as! String,
                                latitude: event.valueForKey("location")!.valueForKey("coordinates")![1] as! CLLocationDegrees,
                                longitude: event.valueForKey("location")!.valueForKey("coordinates")![0] as! CLLocationDegrees)
                        }
                        
                    }
                }
            } catch {
                print(error)
            }
            
        } else {
            let myAlert = UIAlertController(title: "Connection failed!", message: "urlData Equals to NULL!", preferredStyle: UIAlertControllerStyle.Alert)
            
            if let error = reponseError {
                myAlert.message = (error.localizedDescription)
            }
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    
    // Mark : get information from selected pin
    /*func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKAnnotation where annotation.isEqual(selectedAnnotation) {
                // do some actions on non-selected annotations in 'annotation' var
                print(".................................")
            }
        }
    }*/

    
    @IBAction func refreshMapTapped(sender: UIBarButtonItem) {
        
        let location = mapView.userLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func addPinToMapView(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        print(latitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MyAnnotation(coordinate: location, title: title)
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let rightButton: AnyObject! = UIButton(type: UIButtonType.DetailDisclosure)
            rightButton.titleForState(UIControlState.Normal)
            
            pinView!.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("mapToDetail", sender: view)
        }
    }

    func dateFromString (str : String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.dateFromString(str)
        return date!
    }
    
    func stringFromDate (date : NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue?.identifier == "mapToDetail") {
            let vc = segue?.destinationViewController as! EventDetailVC
            
            for event in resArray {
                if ( (sender as! MKAnnotationView).annotation!.coordinate.longitude == (event.valueForKey("location")!.valueForKey("coordinates")![0] as! CLLocationDegrees) &&
                    (sender as! MKAnnotationView).annotation!.coordinate.latitude == (event.valueForKey("location")!.valueForKey("coordinates")![1] as! CLLocationDegrees)) {
                    print("Sucess")
                    selectEvent = event
                    break
                }
            }
            
            let id = selectEvent!.valueForKey("_id") as! NSString
            let title = selectEvent!.valueForKey("title") as! NSString
            let detail = selectEvent!.valueForKey("detail") as! NSString
            let st = selectEvent!.valueForKey("starttime") as! NSString
            let et = selectEvent!.valueForKey("endtime") as! NSString
            let share = selectEvent!.valueForKey("share") as! Bool
            let locationName = selectEvent!.valueForKey("locationName") as! NSString
            let lng = selectEvent!.valueForKey("location")!.valueForKey("coordinates")![0] as! NSNumber
            let lat = selectEvent!.valueForKey("location")!.valueForKey("coordinates")![1] as! NSNumber
            let startTime = st.substringToIndex(st.rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
            let endTime = et.substringToIndex(et.rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
            NSLog("detail ==> %@", detail);
            NSLog("st ==> %@", st);
            NSLog("et ==> %@", et);
            vc.eventDetail = EventModel(title: title, detail: detail, startTime: dateFromString(startTime), endTime: dateFromString(endTime), id: id, share: share, lng: lng, lat: lat, locationName: locationName)
        }
    }
}
