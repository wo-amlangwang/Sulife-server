//
//  EventsTVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/16/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class EventTableVC: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet var EventList: UITableView!
    
    var events : [NSString] = []
    
    // reload data in table
    override func viewDidAppear(animated: Bool) {
        /* get selected date */
        var date : NSDate = dateSelected != nil ? (dateSelected?.convertedDate())! : NSDate()
        
        /* parse date to proper format */
        let sd = stringFromDate(date).componentsSeparatedByString(" ")
        let sdTime = sd[0] + " 00:01"
        let edTime = sd[0] + " 23:59"
        
        /* get data from server */
        let post:NSString = "title=&detail=&starttime=\(sdTime)&endtime=\(edTime)"
        NSLog("PostData: %@",post);
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let postLength:NSString = String( postData.length )

        let url:NSURL = NSURL(string: eventByDateURL)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "post"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                        let myAlert = UIAlertController(title: "Access Failed!", message: "Please Log In Again! ", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                            myAlert .dismissViewControllerAnimated(true, completion: nil)
                            self.performSegueWithIdentifier("eventTableToLogin", sender: self)
                        }))
                        presentViewController(myAlert, animated: true, completion: nil)
                        
                    }
                }
            } catch {
                print(error)
            }
            
            // Parse response string to get events title
            events = responseData.componentsSeparatedByString("title\":\"")
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "urlData Equals to NULL!"
            alertView.message = "Connection fail!"
            if let error = reponseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()

        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of events
        return events.count - 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...

        var event = events[indexPath.row + 1] as NSString
        
        cell.textLabel?.text = event.substringToIndex(event.rangeOfString("\"").location) as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue?.identifier == "showDetail") {
            let vc = segue?.destinationViewController as! EventDetailVC
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                let tempStr : NSString = events[index.row + 1]
                let detail : [NSString] = events[index.row].componentsSeparatedByString("detail\":\"")
                let endTime : [NSString] = tempStr.componentsSeparatedByString("endtime\":\"")
                let startTime : [NSString] = endTime[1].componentsSeparatedByString("starttime\":\"")
                let st = startTime[1].substringToIndex(startTime[1].rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
                let et = endTime[1].substringToIndex(endTime[1].rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
                NSLog("index ==> %d", index.row);
                NSLog("detail ==> %@", detail[1]);
                NSLog("st ==> %@", st);
                NSLog("et ==> %@", et);
                vc.eventDetail = EventModel(title : events[index.row + 1].substringToIndex(events[index.row + 1].rangeOfString("\"").location) as String,
                    detail : detail[1].substringToIndex(detail[1].rangeOfString("\"").location),
                    startTime : dateFromString(st),
                    endTime : dateFromString(et))
            }
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
    
    // Close newevent automatically after saving it
    @IBAction func close(segue: UIStoryboardSegue) {
        NSLog("closed");
        tableView.reloadData();
    }
    
}

// Local Data
// var events:NSMutableArray = NSMutableArray()
/*
var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()

var eventFromDefaults:NSMutableArray? = userDefaults.objectForKey("eventList") as? NSMutableArray

if ((eventFromDefaults) != nil) {
events = eventFromDefaults!
}
*/
// var event:NSDictionary = events.objectAtIndex(indexPath.row) as! NSDictionary