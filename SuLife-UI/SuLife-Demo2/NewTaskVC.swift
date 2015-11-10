//
//  NewTaskVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/6/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class NewTaskVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!

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
    
    @IBAction func addTaskTapped(sender: UIButton) {
        
        // TODO SERVER
        var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var todoList: NSMutableArray? = userDefaults.objectForKey("todoList") as? NSMutableArray
        
        let taskTitle = titleTextField.text!
        let taskDetail = detailTextField.text!
        let taskTime = timeTextField.text!
        
        
        var dataSet:NSMutableDictionary = NSMutableDictionary()
        dataSet.setObject(taskTitle, forKey: "taskTitle")
        dataSet.setObject(taskDetail, forKey: "taskDetail")
        dataSet.setObject(taskTime, forKey: "taskTime")
        
        if (todoList != nil) {
            // data already available, or is first to do
            var newMutableList:NSMutableArray = NSMutableArray()
            for dict:AnyObject in todoList! {
                newMutableList.addObject(dict as! NSDictionary)
            }
            
            userDefaults.removeObjectForKey("todoList")
            newMutableList.addObject(dataSet)
            userDefaults.setObject(newMutableList, forKey: "todoList")
        }
        else
        {
            userDefaults.removeObjectForKey("todoList")
            todoList = NSMutableArray()
            todoList!.addObject(dataSet)
            userDefaults.setObject(todoList, forKey: "todoList")
        }
        
        // save
        userDefaults.synchronize()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    

}
