//
//  LoginVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

//var accountToken = ""


class LoginVC: UIViewController {
    
    //var loginToken:NSString = "no-token"
    
    @IBOutlet weak var userEmailTextField: UITextField!
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
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        
        // fill in required fields
        if ( userEmail.isEmpty )
        {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Log in Failed!"
            alertView.message = "Please enter Email"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if ( userPassword.isEmpty )
        {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Log in Failed!"
            alertView.message = "Please enter Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
        }
        else
        {
            do {
                let post:NSString = "email=\(userEmail)&password=\(userPassword)"
                
                NSLog("PostData: %@",post);
                
                let url:NSURL = NSURL(string:"https://damp-retreat-5682.herokuapp.com/local/login")!
                
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
                            //let token:NSString = jsonData.valueForKey("x-access-token") as! NSString
                            
                            //[jsonData[@"success"] integerValue];
                            
                            NSLog("Success: %@", success);
                          //  accountToken = jsonData.valueForKey("Access_Token") as! NSString as String
                           //  NSLog("accountToken: %@", accountToken);
                            //NSLog("Token: &@", token);
                            
                            //======================================
                            // login successful
                            //======================================
                            
                            if(success == "OK")
                            {
                                NSLog("Login SUCCESS");
                                
                                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setObject(userEmail, forKey: "Email")
                                prefs.setInteger(1, forKey: "isUserLoggedIn")
                                prefs.synchronize()
                                
                                //loginToken = token as NSString
                                
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
                        alertView.message = "Please check your Email and Password!\nIf you haven't registered,\ntry register first!"
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

