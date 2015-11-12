//
//  NewContactTVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class NewContactTVC: UITableViewController , UISearchBarDelegate {
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    var searchResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        
        myCell.textLabel?.text = searchResults[indexPath.row]
        
        return myCell
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        if(searchBar.text!.isEmpty)
        {
            return
        }
        
        doSearch(searchBar.text!)
        
    }
    
    func doSearch(searchWord: String)
    {
        mySearchBar.resignFirstResponder()
        
        let myUrl = NSURL(string: "http://localhost/UISearchBarCaseInsensitiveSearch/findFriends.php")
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "searchWord=\(searchWord)&userId=23";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response: NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if error != nil
                {
                    // display an alert message
                    self.displayAlertMessage(error!.localizedDescription)
                    return
                }
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                    
                    self.searchResults.removeAll(keepCapacity: false)
                    self.myTableView.reloadData()
                    
                    if let parseJSON = json {
                        
                        if let friends  = parseJSON["friends"] as? [AnyObject]
                        {
                            for friendObj in friends
                            {
                                let fullName = (friendObj["first_name"] as! String) + " " + (friendObj["last_name"] as! String)
                                
                                self.searchResults.append(fullName)
                            }
                            
                            self.myTableView.reloadData()
                            
                        } else if(parseJSON["message"] != nil)
                        {
                            
                            let errorMessage = parseJSON["message"] as? String
                            if(errorMessage != nil)
                            {
                                // display an alert message
                                self.displayAlertMessage(errorMessage!)
                            }
                        }
                    }
                    
                } catch {
                    print(error);
                }
                
            }
            
            
        })
        
        
        task.resume()
        
    }
    
    
    func displayAlertMessage(userMessage: String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        mySearchBar.text = ""
        mySearchBar.resignFirstResponder()
    }

}
