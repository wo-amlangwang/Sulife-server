//
//  NotificationDetailVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/13/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class NotificationDetailVC: UIViewController {

    @IBOutlet weak var senderTextView: UITextView!
    @IBOutlet weak var senderEmailTextView: UITextView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    var contactsInit : [NSDictionary] = []
    
    // TODO sender username
    
    var senderDetail : NotificationModel!
    var contactVC : ContactVC!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NSLog("firstname in detail = %@", senderDetail.firstName)
        
        senderTextView.userInteractionEnabled = false
        senderEmailTextView.userInteractionEnabled = false
        let fullname = (senderDetail.firstName as String) + " " + (senderDetail.lastName as String)
        senderEmailTextView.text = senderDetail.email as String
        senderTextView.text = fullname
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptButtonTapped(sender: UIButton) {
        
        if ( isFriend(senderDetail.requestOwnerID) == true ) {
            let myAlert = UIAlertController(title: "Action Failed!", message: "Is Your Firend Already!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewControllerAnimated(true)
            })
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
            acceptButton.userInteractionEnabled = false
            rejectButton.userInteractionEnabled = false
            rejectCancel()
            return
        }
        
        let relationshipID = senderDetail!.relationshipID
        
        let post:NSString = "mailid=\(relationshipID)"
        
        NSLog("PostData Mail: %@",post);
        
        let url:NSURL = NSURL(string: AcceptFriendIDURL)!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
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
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                
                var error: NSError?
                
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                        
                        let success:NSString = jsonResult.valueForKey("message") as! NSString
                        
                        if (success == "OK!") {
                            NSLog("Accept Request Successfully")
                            self.navigationController!.popViewControllerAnimated(true)
                        } else {
                            let myAlert = UIAlertController(title: "Accept Request Failed!", message: "Please Try Again!", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            myAlert.addAction(okAction)
                            self.presentViewController(myAlert, animated:true, completion:nil)
                        }
                    }
                } catch {
                    print(error)
                }
                
            } else {
                let myAlert = UIAlertController(title: "Alert!", message: "Response Error!", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
            
        } else {
            let myAlert = UIAlertController(title: "Alert!", message: "Connection Error!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
    }
    
    @IBAction func rejectButtonTapped(sender: UIButton) {
        
        rejectCancel()
    }
    
    // prevent duplication
    func rejectCancel () {
        
        let relationshipID = senderDetail!.relationshipID
        let post:NSString = "mailid=\(relationshipID)"
        
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: RejectFriendIDURL)!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
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
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                
                var error: NSError?
                
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                        
                        let success:NSString = jsonResult.valueForKey("message") as! NSString
                        
                        if (success == "OK!") {
                            NSLog("Reject Request Successfully")
                            self.navigationController!.popViewControllerAnimated(true)
                            
                        } else {
                            let myAlert = UIAlertController(title: "Reject Request Failed!", message: "Please Try Again!", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            myAlert.addAction(okAction)
                            self.presentViewController(myAlert, animated:true, completion:nil)
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                let myAlert = UIAlertController(title: "Alert!", message: "Response Error!", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
        } else {
            let myAlert = UIAlertController(title: "Alert!", message: "Connection Error!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
        
    }
    
    func isFriend (currentContactID : NSString) -> Bool {
        let url:NSURL = NSURL(string: getContactsURL)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "get";
        
        let postString = "";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
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
                    
                    if (success != "OK! relationships followed") {
                        NSLog("Get Contacts Failed")
                    } else {
                        contactsInit = jsonResult.valueForKey("relationships") as! [NSDictionary]
                        
                        for contact in contactsInit {
                            let contactID = contact.valueForKey("userid2") as! NSString
                            if (currentContactID == contactID) {
                                return true
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
        
        return false
    }

}
