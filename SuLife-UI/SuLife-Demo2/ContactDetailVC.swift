//
//  ContactDetailVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class ContactDetailVC: UIViewController {

    @IBOutlet weak var firstNameTextView: UITextView!
    @IBOutlet weak var lastNameTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    
    var contactDetail : ContactsModel?
    //var contact : NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstNameTextView.userInteractionEnabled = false
        lastNameTextView.userInteractionEnabled = false
        emailTextView.userInteractionEnabled = false
        
        firstNameTextView.text = contactDetail?.firstName as? String
        lastNameTextView.text = contactDetail?.lastName as? String
        emailTextView.text = contactDetail?.email as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteContactTapped(sender: UIButton) {
        // SERVER Not yet implement
        let myAlert = UIAlertController(title: "Action Failed", message: "Feature not yet implemented? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            myAlert .dismissViewControllerAnimated(true, completion: nil)
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
