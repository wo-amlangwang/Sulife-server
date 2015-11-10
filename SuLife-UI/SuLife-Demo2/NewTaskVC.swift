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
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    
    var taskTime : NSString = ""

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
        // var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // var todoList: NSMutableArray? = userDefaults.objectForKey("todoList") as? NSMutableArray
        
        let taskTitle = titleTextField.text!
        let taskDetail = detailTextField.text!
        
        
        // var dataSet:NSMutableDictionary = NSMutableDictionary()
        // dataSet.setObject(taskTitle, forKey: "taskTitle")
        // dataSet.setObject(taskDetail, forKey: "taskDetail")
        // dataSet.setObject(taskTime, forKey: "taskTime")
        
        // Get date from input and convert format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        taskTime = dateFormatter.stringFromDate(taskTimePicker.date)
        
        // Post to server
        let post:NSString = "title=\(taskTitle)&detail=\(taskDetail)&time=\(taskTime)"
        
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: taskURL)!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
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
                
                var error: NSError?
                
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                        
                        let success:NSString = jsonResult.valueForKey("message") as! NSString
                        
                        if (success == "OK!") {
                            NSLog("Add Task Successfully")
                            
                            //var eventToken = jsonResult.valueForKey("Event") as! NSString as String
                            self.navigationController!.popToRootViewControllerAnimated(true)
                            
                        } else {
                            let alertView:UIAlertView = UIAlertView()
                            alertView.title = "Add New Task Failed!"
                            alertView.message = "Please Try Again!"
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            NSLog("1")
                        }
                        
                    }
                } catch {
                    print(error)
                }
                
                
                
                //[jsonData[@"success"] integerValue];
                
            } else {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Add New Task Failed!"
                alertView.message = "System Error!"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                NSLog("2")
            }
            
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Add New Task Failed!"
            alertView.message = "Response Error!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
    
    
    /* Close keyboard when clicking enter*/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        titleTextField.resignFirstResponder();
        detailTextField.resignFirstResponder();
    }

}
