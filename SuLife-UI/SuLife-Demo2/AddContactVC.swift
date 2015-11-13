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
    
    var myuserReturn = NSDictionary()
    var fuckingUserID:NSString = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRequestTapped(sender: UIButton)
    {
        // TODO:
        let userEmail = ContactID.text!
        let post:NSString = "email=\(userEmail)"
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: GetUserIDURL)!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
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
                            fuckingUserID=( UserSB.valueForKey("_id") as? NSString)!
                            NSLog("the fucking userid is: %@", fuckingUserID);
                            if (success == "OK! User followed") {
                                NSLog("Friend foud Successfully")
                                
                                //  NSLog(taker as String)
                                //var eventToken = jsonResult.valueForKey("Event") as! NSString as String
                                
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
                                                    
                                                    myAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
                                                        self.navigationController!.popToRootViewControllerAnimated(true)
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
                
                
                
                //[jsonData[@"success"] integerValue];
                
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        ContactID.resignFirstResponder();
        
    }
}
