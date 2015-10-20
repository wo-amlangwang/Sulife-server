//
//  NewEventVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/16/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class NewEventVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
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

    @IBAction func addEventTapped(sender: UIButton) {
        
        // TODO SERVER
        var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var eventList: NSMutableArray? = userDefaults.objectForKey("eventList") as? NSMutableArray
        
        let eventTitle = titleTextField.text!
        let eventDetail = detailTextField.text!
        let eventStart = startTimeTextField.text!
        let eventEnd = endTimeTextField.text!
        
        
        var dataSet:NSMutableDictionary = NSMutableDictionary()
        dataSet.setObject(eventTitle, forKey: "eventTitle")
        dataSet.setObject(eventDetail, forKey: "eventDetail")
        dataSet.setObject(eventStart, forKey: "eventStartTime")
        dataSet.setObject(eventEnd, forKey: "eventEndTime")
        
        if (eventList != nil) {
            // data already available, or is first to do
            var newMutableList:NSMutableArray = NSMutableArray()
            for dict:AnyObject in eventList! {
                newMutableList.addObject(dict as! NSDictionary)
            }
            
            userDefaults.removeObjectForKey("eventList")
            newMutableList.addObject(dataSet)
            userDefaults.setObject(newMutableList, forKey: "eventList")
        }
        else
        {
            userDefaults.removeObjectForKey("eventList")
            eventList = NSMutableArray()
            eventList!.addObject(dataSet)
            userDefaults.setObject(eventList, forKey: "eventList")
        }
        
        // save
        userDefaults.synchronize()
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
}
