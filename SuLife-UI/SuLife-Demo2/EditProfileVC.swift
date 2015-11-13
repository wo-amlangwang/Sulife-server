//
//  EditProfileVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/10/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        let firstname = firstNameTextField.text! as NSString
        let lastname = lastNameTextField.text! as NSString
        let email = emailTextField.text! as NSString
        
        if (firstname.isEqualToString(userInformation!.firstName as String) && lastname.isEqualToString(userInformation!.lastName as String) && email.isEqualToString(userInformation!.email as String)) {
            let myAlert = UIAlertController(title: "Save Failed!", message: "Nothing Changeed!", preferredStyle: UIAlertControllerStyle.Alert)
            
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
            self.navigationController!.popToRootViewControllerAnimated(true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
