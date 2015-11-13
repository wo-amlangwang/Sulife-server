//
//  NotificationTVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/13/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class NotificationTVC: UITableViewController {
    
    @IBOutlet weak var notificationList: UITableView!
    
    var resArrayNotification : [NSDictionary] = []
    
    var senders : [NSDictionary] = []
    var mailids : [NSString] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* get data from server */
        let url:NSURL = NSURL(string: NotificationURL)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
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
                    
                    if (success != "OK! mail list followed") {
                        NSLog("Get maillist Failed")
                    } else {
                        resArrayNotification = jsonResult.objectForKey("Mails") as! [NSDictionary]
                        for notification in resArrayNotification {
                            let relationshipID = (notification.valueForKey("_id") as? NSString)!
                            let senderID = (notification.valueForKey("sender") as? NSString)!
                            
                            NSLog("the fucking sender is: %@", senderID);
                            NSLog("the fucking mailid is: %@", relationshipID);
                            
                            let sender = getContactsProfileInformation(senderID)
                            
                            NSLog("Sender: %@", sender)
                            
                            senders.append(sender)
                            mailids.append(relationshipID)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of contacts
        return senders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var sender : NSDictionary
        if (senders.count != 0) {
            sender = senders[indexPath.row] as NSDictionary
            let fullname = (sender.valueForKey("firstname") as? String)! + " " + (sender.valueForKey("lastname") as? String)!
            cell.textLabel?.text = fullname
            print(fullname)
        }
        print("Cell Title: \(cell.textLabel?.text)")
        return cell
    }
    
    
   override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {

        if (segue?.identifier == "notificationDetail") {
            let vc = segue?.destinationViewController as! NotificationDetailVC
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                let sender : NSDictionary = senders[index.row]
                let relationshipID : NSString = mailids[index.row]
                NSLog("Mailid To Model => %@", relationshipID)
                
                let firstname = sender.valueForKey("firstname") as! NSString
                NSLog("firstname To Model => %@", firstname)
                
                let lastname = sender.valueForKey("lastname") as! NSString
                NSLog("lastname To Model => %@", lastname)
                let email = sender.valueForKey("email") as! NSString
                NSLog("email To Model => %@", email)
                let requestOwnerID = sender.valueForKey("userid") as! NSString
                NSLog("requestOwnerID To Model => %@", requestOwnerID)
                let isFriend = sender.valueForKey("__v") as! NSNumber
                
                vc.senderDetail = NotificationModel(firstName: firstname, lastName: lastname, email: email, requestOwnerID: requestOwnerID, relationshipID: relationshipID, isFriend : isFriend)
                NSLog("firstname To Model => %@", (vc.senderDetail?.firstName)!)
                
            }
        }
        print("Oh My God!")
    }
    
    func getContactsProfileInformation (contactID : NSString) -> NSDictionary {
        // MARK : get contacts profile
        
        var result = NSDictionary()
        let postString = ""
        let getUserInform = getUserInformation + "/" + (contactID as String)
        
        let contactsProfileUrl:NSURL = NSURL(string: getUserInform)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: contactsProfileUrl)
        request.HTTPMethod = "get"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
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
                    
                    let success: NSString = jsonResult["message"] as! NSString
                    NSLog(success as String)
                    if (success != "OK! Event followed") {
                        NSLog("Get Contacts Information Failed")
                        
                    } else {
                        // Return information
                        NSLog("SUCCESS : Contacts Information")
                        result = jsonResult["profile"] as! NSDictionary
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
        
        
        return result
    }
}
