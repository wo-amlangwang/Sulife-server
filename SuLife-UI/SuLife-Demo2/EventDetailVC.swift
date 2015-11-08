//
//  EventDetailVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/16/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!

    
    var eventDetail : EventModel?
    
    var event:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.userInteractionEnabled = false
        detailTextField.userInteractionEnabled = false
        startTimePicker.userInteractionEnabled = false
        endTimePicker.userInteractionEnabled = false
        
        /*titleTextField.text = event.objectForKey("eventTitle") as? String
        detailTextField.text = event.objectForKey("eventDetail") as? String
        startTimeTextField.text = event.objectForKey("eventStartTime") as? String
        endTimeTextField.text = event.objectForKey("eventEndTime") as? String*/
        
        titleTextField.text = eventDetail?.title as? String
        detailTextField.text = eventDetail?.detail as? String
        startTimePicker.date = (eventDetail?.startTime)!
        endTimePicker.date = (eventDetail?.endTime)!
        
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func deleteItem(sender: AnyObject) {
        
        var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var itemListArray:NSMutableArray = userDefaults.objectForKey("itemList") as! NSMutableArray
        
        var mutableItemList:NSMutableArray = NSMutableArray()
        
        for dict:AnyObject in itemListArray{
            mutableItemList.addObject(dict as! NSDictionary)
        }
        
        mutableItemList.removeObject(event)
        
        userDefaults.removeObjectForKey("itemList")
        userDefaults.setObject(mutableItemList, forKey: "itemList")
        userDefaults.synchronize()
        
        self.navigationController!.popToRootViewControllerAnimated(true)
        
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
    
}
