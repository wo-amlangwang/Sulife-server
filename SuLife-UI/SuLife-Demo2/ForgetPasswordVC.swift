//
//  ForgetPasswordVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/10/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab The blank place, close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    // // Tab The blank place, close keyboard
    func DismissKeyboard () {
        view.endEditing(true)
    }
    
    // Mark : Text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark : Text field END
    
    @IBAction func forgetPasswordTapped(sender: UIButton) {
        
        // TODO send password to user email
        let username = usernameTextField.text!
        if (username.isEmpty) {
            displayAlertMessage("Please Enter The Username")
            return
        }
        // if success is 1
        /* get data from server */
        let post:NSString = "username=\(username)"
        
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: forgetPasswordURL)!
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
                        displayAlertMessage("Password has been sent to \nyour E-mail!")
                    }
                } else {
                    displayAlertMessage("No such user!")
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
    
    func displayAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title: "Forget Password!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
    }
}
