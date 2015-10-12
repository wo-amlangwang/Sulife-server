//
//  LoginVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
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
        
        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        
        if (userEmailStored == userEmail)
        {
            if (userPasswordStored != userPassword)
            {
                //  Password incorrect
                var myAlert = UIAlertController(title: "Alert", message: "Incorrect password!", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
            
            // Login Successful
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    

}
