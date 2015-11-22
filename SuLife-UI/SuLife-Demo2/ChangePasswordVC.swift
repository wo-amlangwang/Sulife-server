//
//  ChangePasswordVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/20/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var repeatNewPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetPasswordTapped(sender: AnyObject) {
        
        let oldPassword = oldPasswordTextField.text!
        let newPassword = newPasswordTextField.text!
        let repeatNewPassword = repeatNewPasswordTextField.text!
        
        if (newPassword != repeatNewPassword) {
            let myAlert = UIAlertController(title: "New Password Does Not Match!", message: "Please Enter the New Password Again!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
        
        /* get data from server */
        let post:NSString = "oldpassword=\(oldPassword)&newpassword=\(newPassword)"
        
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: changePasswordURL)!
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
            
            if(res == nil){
                NSLog("No Response!");
            }
            
            let responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
            
            NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                    
                    let success:NSString = jsonResult.valueForKey("message") as! NSString
                    if (success == "OK!") {
                        let myAlert = UIAlertController(title: "Change Password Successful!", message: "Please Log In Again!", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            userInformation = nil
                        self.performSegueWithIdentifier("changePasswordToLogin", sender: self)
                        }))
                        presentViewController(myAlert, animated: true, completion: nil)
                        
                    } else if (success == "wrong old password") {
                        let myAlert = UIAlertController(title: "Change Password Faild!", message: "Wrong old password!", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated:true, completion:nil)
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
        
    }

}
