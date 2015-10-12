//
//  RegisterVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var userFisrtNameTextField: UITextField!
    @IBOutlet weak var userMidNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
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
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userFirstName = userFisrtNameTextField.text!
        let userMidName = userMidNameTextField.text!
        let userLastName = userLastNameTextField.text!
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        let userRepeatPassword = userRepeatPasswordTextField.text!
        
        // Check for empty fields
        if (userFirstName.isEmpty || userLastName.isEmpty || userEmail.isEmpty || userPassword.isEmpty || userRepeatPassword.isEmpty)
        {
            // Display alert message and return
            displayAlertMessage("Fill Up Required Fields")
        }
        
        // Check password && repeat password
        if (userPassword != userRepeatPassword)
        {
            // Display alert message and return
            displayAlertMessage("Password Do Not Match")
        }
        
        // TODO: Store users data (send to server side)
        NSUserDefaults.standardUserDefaults().setObject(userFirstName, forKey:"userFirstName")
        NSUserDefaults.standardUserDefaults().setObject(userMidName, forKey:"userMidName")
        NSUserDefaults.standardUserDefaults().setObject(userLastName, forKey:"userLastName")
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey:"userEmail")
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey:"userPassword")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        // Display alert Message with confliction
        var myAlert = UIAlertController(title: "Registration Successful!", message: "Welcome to SuLife!\nPlease verify your information through email and then login!", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default) { action in self.dismissViewControllerAnimated(true, completion: nil) }
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
        
    }
    
    func displayAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
        
    }
    
    @IBAction func iHaveAnAccountButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
