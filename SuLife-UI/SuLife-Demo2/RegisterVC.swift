//
//  RegisterVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userFisrtNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab The blank place, close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard () {
        view.endEditing(true)
    }
    
    // Mark : Text Filed position
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.userFisrtNameTextField {
            self.userLastNameTextField.becomeFirstResponder()
        } else if textField == self.userLastNameTextField {
            self.usernameTextField.becomeFirstResponder()
        } else if textField == self.usernameTextField {
            self.userEmailTextField.becomeFirstResponder()
        } else if textField == self.userEmailTextField {
            self.userPasswordTextField.becomeFirstResponder()
        } else if textField == self.userPasswordTextField {
            self.userRepeatPasswordTextField.becomeFirstResponder()
        } else if textField == self.userRepeatPasswordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == usernameTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 20), animated: true)
        } else if (textField == userEmailTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
        } else if (textField == userPasswordTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 180), animated: true)
        } else if (textField == userRepeatPasswordTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 260), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 120), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        
        myActivityIndicator.startAnimating()
        
        let userFirstName = userFisrtNameTextField.text!
        let userLastName = userLastNameTextField.text!
        let username = usernameTextField.text!
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        let userRepeatPassword = userRepeatPasswordTextField.text!
        
        
        // Check for empty fields
        if (userFirstName.isEmpty || userLastName.isEmpty || username.isEmpty || userEmail.isEmpty || userPassword.isEmpty || userRepeatPassword.isEmpty)
        {
            // Display alert message and return
            displayAlertMessage("Fill Up Required Fields")
        }
            
            // Check password && repeat password
        else if (userPassword != userRepeatPassword)
        {
            // Display alert message and return
            displayAlertMessage("Password Does Not Match")
        }
            
            // TODO: Store users data (send to server side)
            
        else
        {
            do {
                
                // Change
                let post:NSString = "email=\(username)&password=\(userPassword)"
                
                NSLog("PostData: %@",post);
                
                let url:NSURL = NSURL(string: registerURL)!
                let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData?
                
                do {
                    urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                } catch let error as NSError {
                    reponseError = error
                    urlData = nil
                }
                
                myActivityIndicator.stopAnimating()
                
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    
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
                        
                        //[jsonData[@"success"] integerValue];
                        
                        NSLog("Success: %@", success);
                        if(success == "OK")
                        {
                            NSLog("Sign Up SUCCESS");
                            
                            //======================================
                            // Send firstName & lastName to database
                            //======================================
                            
                            sendUserPrfileToDB(accountToken, firstname: userLastName, lastname: userFirstName, userEmail: userEmail)
                            
                            //=======================================
                            // Auot login
                            //=======================================
                            
                            autoLogin(username, userPassword: userPassword)
                            
                            // set user's information
                            setUserInformation(userFirstName, lastName : userLastName, email : userEmail, id : accountToken)
                            
                            let myAlert = UIAlertController(title: "Registration Successful", message: "Hi \(userFirstName)!\n Welcom do SuLife!", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                                self.performSegueWithIdentifier("registerToMain", sender: self)
                            })
                            
                            myAlert.addAction(okAction)
                            self.presentViewController(myAlert, animated:true, completion:nil)
                            
                            
                        }
                        else
                        {
                            var error_msg:NSString
                            
                            if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            
                            let myAlert = UIAlertController(title: "Sign Up Failed!", message: error_msg as String, preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            myAlert.addAction(okAction)
                            self.presentViewController(myAlert, animated:true, completion:nil)
                        }
                        
                    }
                    else
                    {
                        let myAlert = UIAlertController(title: "Sign Up Failed!", message: "Email already exist! Try login!", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated:true, completion:nil)
                    }
                }
                else
                {
                    let myAlert = UIAlertController(title: "Sign Up Failed!", message: "Connection Failed", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated:true, completion:nil)
                }
            }
            catch
            {
                let myAlert = UIAlertController(title: "Sign Up Failed!", message: "Server Error", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
        }
    }
    
    func displayAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
    }
    
    
    //======================================
    // Send firstName & lastName to database
    //======================================
    
    func sendUserPrfileToDB(token:NSString, firstname:String, lastname:String, userEmail: String)
    {
        do {
            // change
            let post:NSString = "firstname=\(firstname)&lastname=\(lastname)&email=\(userEmail)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: profileURL)!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(token as String, forHTTPHeaderField: "x-access-token")
            
            
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
                    
                    //var error: NSError?
                }
            }
        }
    }
    
    //==================================
    // Auto login
    //==================================
    func autoLogin (username: String, userPassword: String) {
        do {
            let post:NSString = "email=\(username)&password=\(userPassword)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string:"https://damp-retreat-5682.herokuapp.com/local/login")!
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            
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
                        
                        //[jsonData[@"success"] integerValue];
                        
                        NSLog("Success: %@", success);
                        
                        if(success == "OK")
                        {
                            NSLog("Login SUCCESS");
                            
                            // store information as globa
                            
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username, forKey: "username")
                            prefs.setInteger(1, forKey: "isUserLoggedIn")
                            prefs.synchronize()
                            
                        } else {
                            var error_msg:NSString
                            
                            if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            let myAlert = UIAlertController(title: "Sign Up Failed!", message: error_msg as String, preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            myAlert.addAction(okAction)
                            self.presentViewController(myAlert, animated:true, completion:nil)
                        }
                    }
                } else {
                    let myAlert = UIAlertController(title: "Login Failed!", message: "Please check your Username and Password!\nIf you haven't registered,\ntry register first!", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated:true, completion:nil)
                }
            } else {
                let myAlert = UIAlertController(title: "Login Failed!", message: "Connection Failed", preferredStyle: UIAlertControllerStyle.Alert)
                
                if let error = reponseError {
                    myAlert.message = (error.localizedDescription)
                }
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
                
            }
        } catch {
            let myAlert = UIAlertController(title: "Login Failed!", message: "Server Error", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
    }
    
    func setUserInformation(firstName : String, lastName : String, email : String, id : NSString) {
        userInformation = UserModel(firstName: firstName as NSString, lastName: lastName as NSString, email: email as
            NSString, id: id)
        print("Register : Profile : name = \(userInformation?.lastName)")
    }
}
