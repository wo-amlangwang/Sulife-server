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

let getContactsURL = "https://damp-retreat-5682.herokuapp.com/getFriends"
let deleteContactURL = "https://damp-retreat-5682.herokuapp.com/deleteFriend"

let NotificationURL = "https://damp-retreat-5682.herokuapp.com/getMail"
let GetUserIDURL = "https://damp-retreat-5682.herokuapp.com/findUser"
let AcceptFriendIDURL = "https://damp-retreat-5682.herokuapp.com/acceptFriendRequest"
let RejectFriendIDURL = "https://damp-retreat-5682.herokuapp.com/rejectFriendRequest"

let addFriendURL = "https://damp-retreat-5682.herokuapp.com/friendRequest"
let getUserInformation = "https://damp-retreat-5682.herokuapp.com/getUserInformation"
let getFriendEvents = "https://damp-retreat-5682.herokuapp.com/eventf"

let forgetPasswordURL = "https://damp-retreat-5682.herokuapp.com/resetPassword"
let changePasswordURL = "https://damp-retreat-5682.herokuapp.com/changePassword"

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //var loginToken:NSString = "no-token"
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Tab The blank place, close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark : Text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.userPasswordTextField.becomeFirstResponder()
        } else if textField == self.userPasswordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == userPasswordTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 20), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
    func DismissKeyboard () {
        view.endEditing(true)
    }
    // Mark : Text Field End
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        myActivityIndicator.startAnimating()
        
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
                
                myActivityIndicator.stopAnimating()
                
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
                        let firstName = jsonInform.valueForKey("firstname") as! NSString
                        let lastName = jsonInform.valueForKey("lastname") as! NSString
                        let email = jsonInform.valueForKey("email") as! NSString
                        let id = jsonInform.valueForKey("userid") as! NSString
                        
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

