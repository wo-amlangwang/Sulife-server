//
//  ToDoListTVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/6/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class ToDoListTVC: UITableViewController {

    // MARK: Properties
    
    @IBOutlet var TodoList: UITableView!
    
    var resArray : [NSDictionary] = []
    
    // reload data in table
    override func viewDidAppear(animated: Bool) {
        /* get selected date */
        let date : NSDate = dateSelected != nil ? (dateSelected?.convertedDate())! : NSDate()
        
        /* parse date to proper format */
        let sd = stringFromDate(date).componentsSeparatedByString(" ")
        let taskTime = sd[0] + " 00:00"
        
        /* get data from server */
        let post:NSString = "title=&detail=&establishTime=\(taskTime)"
        NSLog("PostData: %@",post);
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let postLength:NSString = String( postData.length )
        
        let url:NSURL = NSURL(string: taskByDateURL)!
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
                    
                    if (success != "OK! Task list followed") {
                        NSLog("Get Task Failed")
                        let myAlert = UIAlertController(title: "Access Failed!", message: "Please Log In Again! ", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                            myAlert .dismissViewControllerAnimated(true, completion: nil)
                            self.performSegueWithIdentifier("TodoListToLogin", sender: self)
                        }))
                        presentViewController(myAlert, animated: true, completion: nil)
                        
                    } else {
                        resArray = jsonResult.valueForKey("Tasks") as! [NSDictionary]
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
        // return number of tasks
        return resArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        
        let task = resArray[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = task.valueForKey("title") as? String;
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        NSLog("tt ==> %@", "in");
        if (segue?.identifier == "showTaskDetail") {
            let vc = segue?.destinationViewController as! TaskDetailVC
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                let task : NSDictionary = resArray[index.row]
                let id = task.valueForKey("_id") as? NSString
                let title = task.valueForKey("title") as? NSString
                let detail = task.valueForKey("detail") as? NSString
                let tt = task.valueForKey("establishTime") as! NSString
                let share = task.valueForKey("finished") as? Bool
                let taskTime = tt.substringToIndex(tt.rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
                NSLog("detail ==> %@", detail!);
                NSLog("tt ==> %@", tt);
                vc.taskDetail = TaskModel(title: title!, detail: detail!, time: dateFromString(taskTime), id: id!, share: share!)
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

}
