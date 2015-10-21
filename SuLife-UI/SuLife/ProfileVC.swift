//
//  ProfileVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/14/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButtonTapped(sender: UIBarButtonItem) {
        let myAlert = UIAlertController(title: "Log Out", message: "Are You Sure to Log Out ? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        myAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            myAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        
        myAlert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (action: UIAlertAction!) in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.performSegueWithIdentifier("profileToLogin", sender: self)
        }))
        
        presentViewController(myAlert, animated: true, completion: nil)
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
