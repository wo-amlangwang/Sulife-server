//
//  ProfileVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/14/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var fullNameLable: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        headImage.layer.masksToBounds = true
        headImage.layer.cornerRadius = self.view.frame.width / 8.5
        
        fullNameLable.text = (userInformation!.firstName as String) + " " + (userInformation!.lastName as String)
        emailLable.text = userInformation!.email as String
        self.extendedLayoutIncludesOpaqueBars = true
        self.tabBarController!.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        let myAlert = UIAlertController(title: "Log Out", message: "Are You Sure to Log Out ? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        myAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            myAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        
        myAlert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (action: UIAlertAction!) in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
            NSUserDefaults.standardUserDefaults().synchronize()
            userInformation = nil
            self.performSegueWithIdentifier("profileToLogin", sender: self)
        }))
        
        presentViewController(myAlert, animated: true, completion: nil)
    }
}
