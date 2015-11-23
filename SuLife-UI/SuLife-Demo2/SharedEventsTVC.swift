//
//  SharedEventsTVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/21/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class SharedEventsTVC: UITableViewController {

    // MARK: Properties
    
    @IBOutlet weak var EventList: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var resArray : [NSDictionary] = []
    var searchResults : [String] = []
    var searchActive : Bool = false
    
    var contactDetail : ContactsModel?
    
    // reload data in table
    override func viewWillAppear(animated: Bool) {

        let contactID = contactDetail!.id
        
        /* get data from server */
        let post:NSString = "userid=\(contactID)"
        NSLog("PostData: %@",post);
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let url:NSURL = NSURL(string: getFriendEvents)!
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
                        NSLog("Get Event Failed")
                    } else {
                        resArray = jsonResult.valueForKey("Events") as! [NSDictionary]
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
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.registerClass(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        EventList.delegate = self
        EventList.dataSource = self
        EventList.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        mySearchBar.text = ""
        mySearchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("SearchText: \(searchText)")
        
        var eventString : [String] = []
        for event in resArray {
            eventString.append(event.valueForKey("title") as! String)
        }
        
        searchResults = eventString.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        searchActive = true;
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of events
        print("search activate: \(searchActive)")
        if(searchActive) {
            print("Search count = \(searchResults.count)")
            return searchResults.count
        }
        return resArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var event : NSDictionary
        print("search activate: \(searchActive)")
        // Configure the cell...
        if(searchActive){
            cell.textLabel?.text = searchResults[indexPath.row]
        } else {
            event = resArray[indexPath.row] as NSDictionary
            cell.textLabel?.text = event.valueForKey("title") as? String
        }
        print("Cell Title: \(cell.textLabel?.text)")
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue?.identifier == "sharedEventsToDetail") {
            let vc = segue?.destinationViewController as! SharedEventVC
            let indexPath = tableView.indexPathForSelectedRow
            NSLog("THE INDEX NUMBER IS: %d", indexPath!.row)
            if let index = indexPath {
                var event : NSDictionary!
                if (searchActive) {
                    let searchStr = searchResults[index.row]
                    for e in resArray {
                        if (e.valueForKey("title") as? NSString == searchStr) {
                            event = e
                            break;
                        }
                    }
                } else {
                    event = resArray[index.row]
                }
                let id = event.valueForKey("_id") as! NSString
                let title = event.valueForKey("title") as! NSString
                let detail = event.valueForKey("detail") as! NSString
                let st = event.valueForKey("starttime") as! NSString
                let et = event.valueForKey("endtime") as! NSString
                let share = event.valueForKey("share") as! Bool
                let locationName = event.valueForKey("locationName") as! NSString
                let lng = event.valueForKey("location")!.valueForKey("coordinates")![0] as! NSNumber
                let lat = event.valueForKey("location")!.valueForKey("coordinates")![1] as! NSNumber
                let startTime = st.substringToIndex(st.rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
                let endTime = et.substringToIndex(et.rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
                NSLog("detail ==> %@", detail);
                NSLog("st ==> %@", st);
                NSLog("et ==> %@", et);
                vc.eventDetail = EventModel(title: title, detail: detail, startTime: dateFromString(startTime), endTime: dateFromString(endTime), id: id, share: share, lng: lng, lat: lat, locationName: locationName)            }
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

}
