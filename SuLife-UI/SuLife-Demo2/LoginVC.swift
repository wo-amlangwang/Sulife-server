//
//  LoginVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

var accountToken = ""
var userInformation : UserModel?

let registerURL = "https://damp-retreat-5682.herokuapp.com/register"
let loginURL = "https://damp-retreat-5682.herokuapp.com/local/login"
let eventURL = "https://damp-retreat-5682.herokuapp.com/event"
let eventByDateURL = "https://damp-retreat-5682.herokuapp.com/eventd"
let profileURL = "https://damp-retreat-5682.herokuapp.com/profile"

let taskURL = "https://damp-retreat-5682.herokuapp.com/task"
let taskByDateURL = "https://damp-retreat-5682.herokuapp.com/taskd"

class LoginVC: UIViewController {
    
    //var loginToken:NSString = "no-token"
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        // TODO: from server
        let username = usernameTextField.text!
        let userPassword = userPasswordTextField.text!
        
        // fill in required fields
        if ( username.isEmpty )
        {
            let myAlert = UIAlertController(title: "Login Failed!", message: "Please enter Username", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
        else if ( userPassword.isEmpty )
        {
            let myAlert = UIAlertController(title: "Login Failed!", message: "Please enter Password", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
        else
        {
            do {
                // Change
                let post:NSString = "email=\(username)&password=\(userPassword)"
                
                NSLog("PostData: %@",post);
                
                let url:NSURL = NSURL(string: loginURL)!
                
                let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength:NSString = String( postData.length )
                
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData?
                do {
                    urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                    // urlData = try NSURLSession.dataTaskWithRequest(request, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?)
                } catch let error as NSError {
                    reponseError = error
                    urlData = nil
                }
                
                if ( urlData != nil )
                {
                    let res = response as! NSHTTPURLResponse!;
                    if (res != nil)
                    {
                        NSLog("Response code: %ld", res.statusCode);
                        
                        if (res.statusCode >= 200 && res.statusCode < 300)
                        {
                            let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                            
                            NSLog("Response ==> %@", responseData);
                            
                            //var error: NSError?
                            
                            let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary

                            
                            let success:NSString = jsonData.valueForKey("message") as! NSString
                            
                            NSLog("Success: %@", success);
                            accountToken = jsonData.valueForKey("Access_Token") as! NSString as String
                            NSLog("accountToken: %@", accountToken);
                            
                            //======================================
                            // login successful
                            //======================================
                            
                            if(success == "OK")
                            {
                                NSLog("Login SUCCESS");
                                
                                getUserInformation()
                                
                                let isUserLoggedIn : Bool = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
                                
                                if (isUserLoggedIn)
                                {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                else {
                                
                                    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                    prefs.setObject(username, forKey: "username")
                                    prefs.setInteger(1, forKey: "isUserLoggedIn")
                                    prefs.synchronize()
                                
                                
                                self.performSegueWithIdentifier("loginToMain", sender: self)
                                }
                                
                            } else {
                                var error_msg:NSString
                                
                                if jsonData["error_message"] as? NSString != nil {
                                    error_msg = jsonData["error_message"] as! NSString
                                } else {
                                    error_msg = "Unknown Error"
                                }
                                
                                let myAlert = UIAlertController(title: "Sign in Failed!", message: error_msg as String, preferredStyle: UIAlertControllerStyle.Alert)
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                myAlert.addAction(okAction)
                                self.presentViewController(myAlert, animated:true, completion:nil)
                            }
                        }
                    } else {
                        let myAlert = UIAlertController(title: "Sign in Failed!", message: "Please check your username and Password!\nIf you haven't registered,\ntry register first!", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated:true, completion:nil)
                    }
                } else {
                    let myAlert = UIAlertController(title: "Sign in Failed!", message: "Connection fail!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    if let error = reponseError {
                        myAlert.message = (error.localizedDescription)
                    }
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated:true, completion:nil)
                }
            } catch {
                let myAlert = UIAlertController(title: "Sign in Failed!", message: "Server Error", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
        }
    }
    
    func getUserInformation () {
        // user's information UserModel
        
        print("----------------------------------------")
        
        // let profileUrl = profileURL + "/" + accountToken! as String)
        let profileUrl:NSURL = NSURL(string: profileURL)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: profileUrl)
        request.HTTPMethod = "get"
        request.HTTPBody = nil
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
            
            // var error: NSError?
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                    
                    let success: NSString = jsonResult.valueForKey("message") as! NSString
                    
                    if (success != "OK! Profile followed") {
                        NSLog("Get Profile Failed")
                        let myAlert = UIAlertController(title: "Access Failed!", message: "Please Log In Again! ", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                            myAlert .dismissViewControllerAnimated(true, completion: nil)
                            self.performSegueWithIdentifier("eventTableToLogin", sender: self)
                        }))
                        presentViewController(myAlert, animated: true, completion: nil)
                        
                    } else {
                        let jsonInform = jsonResult.valueForKey("profile") as! NSDictionary
                        let firstName = ""/*jsonResult[1]!.valueForKey("firstname") as! NSString*/
                        let lastName = jsonInform.valueForKey("lastname") as! NSString
                        let email = ""/*jsonResult[1]!.valueForKey("email") as! NSString*/
                        let id = accountToken
                        
                        userInformation = UserModel(firstName: firstName, lastName: lastName, email: email, id: id)
                        
                        NSLog("SUCCESS : Profile : name = \(userInformation?.lastName)")
                    }
                }
            } catch {
                print(error) 
            }
        }
    }
}

