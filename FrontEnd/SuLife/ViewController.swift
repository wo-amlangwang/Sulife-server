//
//  ViewController.swift
//  SuLife
//
//  Created by Sine Feng on 9/14/15.
//  Copyright (c) 2015 Sine Feng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        
        if (!isUserLoggedIn)
        {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        var refreshAlert = UIAlertController(title: "Log Out", message: "Are You Sure to Log Out ? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (action: UIAlertAction!) in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.performSegueWithIdentifier("loginView", sender: self)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        //let alertView:UIAlertView = UIAlertView()
        //alertView.title = "Alert"
        //alertView.message = "Are you sure to logout?"
        //alertView.delegate = self
        //alertView.addButtonWithTitle("Cancel")
        //alertView.addButtonWithTitle("Logout")
        //alertView.show()
        
        
    }
    
}


