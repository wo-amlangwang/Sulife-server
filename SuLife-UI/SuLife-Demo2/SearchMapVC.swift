//
//  SearchMapVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/22/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit
import MapKit


class SearchMapVC: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var initialLocation = CLLocation()
    var newCoord : CLLocationCoordinate2D!
    
    var placeNameForEvent : String?
    var coordinateForEvent: CLLocationCoordinate2D?
    
    @IBOutlet var mapView: MKMapView!
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    @IBAction func showSearchBar(sender: AnyObject) {
        self.mapView.delegate = self
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
        
    }
    
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
        
        // MARK : drop pin
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)

    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        
        if self.mapView.annotations.count != 0 {
            for annotationShouldRemove in self.mapView.annotations {
                self.mapView.removeAnnotation(annotationShouldRemove)
            }
        }
        
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        newCoord = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        let newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord!
        
        newAnotation.title = "Custom"
        mapView.addAnnotation(newAnotation)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UISearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
    
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            for annotationShouldRemove in self.mapView.annotations {
                self.mapView.removeAnnotation(annotationShouldRemove)
            }
        }
    
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        localSearchRequest.region = MKCoordinateRegion(center: initialLocation.coordinate, span: span)
        
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler ({ (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            for item in localSearchResponse!.mapItems {
                self.addPinToMapView(item.name!, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                if (item == localSearchResponse!.mapItems.first) {
                    let center = CLLocationCoordinate2D(latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                    
                    self.mapView.setRegion(region, animated: true)
                }
            }
        })
    }
    
    func addPinToMapView(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MyAnnotation(coordinate: location, title: title)
        
        mapView.addAnnotation(annotation)
    }


    @IBAction func currentLocationTapped(sender: UIButton) {
        let location = mapView.userLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
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
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKAnnotation where annotation.isEqual(selectedAnnotation) {
                // do some actions on non-selected annotations in 'annotation' var
                self.placeNameForEvent = annotation.title!
                print(self.placeNameForEvent)
                self.coordinateForEvent = annotation.coordinate
            }
        }
    }
}
