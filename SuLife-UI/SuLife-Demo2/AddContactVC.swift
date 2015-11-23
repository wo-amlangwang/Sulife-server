//
//  AddContactVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class AddContactVC: UIViewController {

    // CONTACT ID
    @IBOutlet weak var ContactID: UITextField!
    
    var contactsInit : [NSDictionary] = []
    
    var myuserReturn = NSDictionary()
    var fuckingUserID:NSString = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab The blank place, close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard () {
        view.endEditing(true)
    }
    
    
    // Mark : Text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Mark : Text field END
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRequestTapped(sender: UIButton)
    {
        // TODO:
        let userEmail = ContactID.text!
        if (userEmail.isEmpty) {
            let myAlert = UIAlertController(title: "Send Request Failed!", message: "Please enter the username!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
        
        let post:NSString = "email=\(userEmail)"
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: GetUserIDURL)!
        
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
                        
                        let nullDetector: AnyObject = NSNull()
                        if let UserSB:NSDictionary = jsonResult.objectForKey("user") as? NSDictionary {
                            //let UserSB:NSDictionary = jsonResult.objectForKey("user") as! NSDictionary
                            fuckingUserID = ( UserSB.valueForKey("_id") as? NSString)!
                            NSLog("the fucking userid is: %@", fuckingUserID);
                            if (success == "OK! User followed") {
                                NSLog("Friend foud Successfully")
                                
                                
                                if ( fuckingUserID == userInformation!.id ) {
                                    let myAlert = UIAlertController(title: "Send Request Failed!", message: "Don not add yourself!", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.presentViewController(myAlert, animated:true, completion:nil)
                                    return
                                }
                                
                                
                                // Mark: Check if is friend
                                if ( isFriend(fuckingUserID) == true ) {
                                    let myAlert = UIAlertController(title: "Send Request Failed!", message: "Is Your Firend Already!", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                    myAlert.addAction(okAction)
                                    self.presentViewController(myAlert, animated:true, completion:nil)
                                    return
                                }
                                
                                let post:NSString = "taker=\(fuckingUserID)"
                                
                                NSLog("PostData: %@",post);
                                
                                let url:NSURL = NSURL(string: addFriendURL)!
                                
                                let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                                
                                let postLength:NSString = String( postData.length )
                                
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
                                    
                                    NSLog("Response code for the add friend: %ld", res.statusCode);
                                    
                                    if (res.statusCode >= 200 && res.statusCode < 300)
                                    {
                                        let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                                        
                                        NSLog("Response ==> %@", responseData);
                                        
                                        var error: NSError?
                                        
                                        do {
                                            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                                                
                                                let success:NSString = jsonResult.valueForKey("message") as! NSString
                                                
                                                if (success == "OK!") {
                                                    
                                                    let myAlert = UIAlertController(title: "Friend Request Sended!", message: "Please wait for the reply! ", preferredStyle: UIAlertControllerStyle.Alert)
                                                    
                                                    myAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action: UIAlertAction!) in
                                                        self.navigationController?.popViewControllerAnimated(true)
                                                    }))
                                                    presentViewController(myAlert, animated: true, completion: nil)
                                                }
                                            }
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    
                                }
                            } else {
                                let myAlert = UIAlertController(title: "Add New Event Failed!", message: "Please Try Again!", preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                myAlert.addAction(okAction)
                                self.presentViewController(myAlert, animated:true, completion:nil)
                            }
                        }
                        else
                        {
                            let myAlert = UIAlertController(title: "Send Friend Request Failed!", message: "No Such User!\nPlease check User's ID!", preferredStyle: UIAlertControllerStyle.Alert)
                            myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                            presentViewController(myAlert, animated: true, completion: nil)
                            
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                let myAlert = UIAlertController(title: "Add New Event Failed!---002", message: "System Error!---002", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
            
        } else {
            let myAlert = UIAlertController(title: "Add New Event Failed---003!", message: "Response Error!---003", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
        
        NSLog("the userid is: ",fuckingUserID)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        ContactID.resignFirstResponder();
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
