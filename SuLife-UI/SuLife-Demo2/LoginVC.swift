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
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Login Failed!"
            alertView.message = "Please enter username"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if ( userPassword.isEmpty )
        {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Login Failed!"
            alertView.message = "Please enter Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
        }
        else
        {
            do {
                let post:NSString = "username=\(username)&password=\(userPassword)"
                
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
                                
                                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setObject(username, forKey: "username")
                                prefs.setInteger(1, forKey: "isUserLoggedIn")
                                prefs.synchronize()
                                
                                let startViewController = self.storyboard?.instantiateViewControllerWithIdentifier("startView") as! StartVC
                                
                                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.window?.rootViewController = startViewController
                                appDelegate.window?.makeKeyAndVisible()

                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                var error_msg:NSString
                                
                                if jsonData["error_message"] as? NSString != nil {
                                    error_msg = jsonData["error_message"] as! NSString
                                } else {
                                    error_msg = "Unknown Error"
                                }
                                let alertView:UIAlertView = UIAlertView()
                                alertView.title = "Sign in Failed!"
                                alertView.message = error_msg as String
                                alertView.delegate = self
                                alertView.addButtonWithTitle("OK")
                                alertView.show()
                            }
                        }
                    } else {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = "Please check your username and Password!\nIf you haven't registered,\ntry register first!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection fail!"
                    if let error = reponseError {
                        alertView.message = (error.localizedDescription)
                    }
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } catch {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Server Error"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
    }
    
    func getUserInformation () {
        // user's information UserModel
        
        // let profileUrl = profileURL + "/" + accountToken! as String)
        let profileUrl:NSURL = NSURL(string: profileURL)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: profileUrl)
        request.HTTPMethod = "get"
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
                        userInformation?.firstName = jsonResult.valueForKey("firstname") as! NSString
                        userInformation?.lastName = jsonResult.valueForKey("lastname") as! NSString
                        userInformation?.email = jsonResult.valueForKey("email") as! NSString
                        userInformation?.id = accountToken
                    }
                }
            } catch {
                print(error) 
            }
        }
    }
}

