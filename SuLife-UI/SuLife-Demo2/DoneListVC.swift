//
//  ToDoListTVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/6/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class DoneListVC: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet var TodoList: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var resArray : [NSDictionary] = []
    var finishedList : [NSDictionary] = []
    var searchResults : [String] = []
    var searchActive : Bool = false
    
    // reload data in table
    override func viewWillAppear(animated: Bool) {
        
        /* get selected date */
        let date : NSDate = dateSelected != nil ? (dateSelected?.convertedDate())! : NSDate()
        
        /* parse date to proper format */
        let sd = stringFromDate(date).componentsSeparatedByString(" ")
        let taskTime = sd[0] + " 00:01"
        
        /* get data from server */
        let post:NSString = "title=&detail=&establishTime=\(taskTime)"
        NSLog("PostData: %@",post);
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        let url:NSURL = NSURL(string: taskByDateURL)!
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
                    
                    if (success != "OK! Task list followed") {
                        NSLog("Get Task Failed")
                        let myAlert = UIAlertController(title: "Access Failed!", message: "Please Log In Again! ", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                            myAlert .dismissViewControllerAnimated(true, completion: nil)
                        }))
                        presentViewController(myAlert, animated: true, completion: nil)
                        
                    } else {
                        resArray = jsonResult.valueForKey("Tasks") as! [NSDictionary]
                        for task in resArray {
                            if ((task.objectForKey("finished") as! Bool) == true) {
                                finishedList.append(task)
                            }
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
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodoList.delegate = self
        TodoList.dataSource = self
        TodoList.delegate = self
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
        
        var taskString : [String] = []
        for task in finishedList {
            taskString.append(task.valueForKey("title") as! String)
        }
        
        searchResults = taskString.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        searchActive = true;
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of tasks
        print("search activate: \(searchActive)")
        if(searchActive) {
            print("Search count = \(searchResults.count)")
            return searchResults.count
        }
        return finishedList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("doneTaskCell", forIndexPath: indexPath) as UITableViewCell
        
        var task : NSDictionary
        print("search activate: \(searchActive)")
        // Configure the cell...
        if(searchActive){
            cell.textLabel?.text = searchResults[indexPath.row]
        } else {
            task = finishedList[indexPath.row] as NSDictionary
            cell.textLabel?.text = task.valueForKey("title") as? String
        }
        print("Cell Title: \(cell.textLabel?.text)")
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue?.identifier == "donelstToDetail") {
            let vc = segue?.destinationViewController as! TaskDetailVC
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                
                var task : NSDictionary!
                if (searchActive) {
                    let searchStr = searchResults[index.row]
                    for e in finishedList {
                        if ((e.valueForKey("title") as! NSString) == searchStr) {
                            task = e
                            break;
                        }
                    }
                } else {
                    task = finishedList[index.row]
                }
        
                let id = task.valueForKey("_id") as! NSString
                let title = task.valueForKey("title") as! NSString
                let detail = task.valueForKey("detail") as! NSString
                let tt = task.valueForKey("establishTime") as! NSString
                let finish = task.objectForKey("finished") as! Bool
                let taskTime = tt.substringToIndex(tt.rangeOfString(".").location - 3).stringByReplacingOccurrencesOfString("T", withString: " ")
                NSLog("detail ==> %@", detail);
                NSLog("tt ==> %@", tt);
                vc.taskDetail = TaskModel(title: title, detail: detail, time: dateFromString(taskTime), finish: finish, id: id)
                finishedList = []
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
