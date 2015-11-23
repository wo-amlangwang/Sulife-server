//
//  EditProfileVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/10/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstNameTextField.userInteractionEnabled = true
        lastNameTextField.userInteractionEnabled = true
        emailTextField.userInteractionEnabled = true
        
        firstNameTextField.text = userInformation?.firstName as? String
        lastNameTextField.text = userInformation?.lastName as? String
        emailTextField.text = userInformation?.email as? String
        
        // Tab The blank place, close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard () {
        view.endEditing(true)
    }
    
    // Mark : Text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.firstNameTextField {
            self.lastNameTextField.becomeFirstResponder()
        } else if textField == self.lastNameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == emailTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    // Mark : Text field END
    
    /*// MARK : Ask if save before back
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print(".......1 .......")
        if (self.isMovingFromParentViewController()) {
            let myAlert = UIAlertController(title: "Alert", message: "Leave without saving?", preferredStyle: UIAlertControllerStyle.Alert)
            print(".......2.......")
            myAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                myAlert .dismissViewControllerAnimated(true, completion: nil)
            }))
            
            myAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action: UIAlertAction!) in
                self.saveAction()
            }))
            presentViewController(myAlert, animated: true, completion: nil)
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        saveAction()
    }
    
    func saveAction () {
        let firstname = firstNameTextField.text! as NSString
        let lastname = lastNameTextField.text! as NSString
        let email = emailTextField.text! as NSString
        
        if (firstname.isEqualToString(userInformation!.firstName as String) && lastname.isEqualToString(userInformation!.lastName as String) && email.isEqualToString(userInformation!.email as String)) {
            let myAlert = UIAlertController(title: "Save Failed!", message: "Nothing Changed!", preferredStyle: UIAlertControllerStyle.Alert)
            
            myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                myAlert .dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(myAlert, animated: true, completion: nil)
        } else {
            let post:NSString = "firstname=\(firstname)&lastname=\(lastname)&email=\(email)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: profileURL)!
            
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
                    
                    //var error: NSError?
                }
            }
            // return to profile
            userInformation = UserModel(firstName: firstname, lastName: lastname, email: email, id: accountToken)
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
}
