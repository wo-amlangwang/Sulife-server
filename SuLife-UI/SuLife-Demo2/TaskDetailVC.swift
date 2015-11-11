//
//  TaskDetailVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/6/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class TaskDetailVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    
    var taskDetail : TaskModel?
    
    var task:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.userInteractionEnabled = false
        detailTextField.userInteractionEnabled = false
        taskTimePicker.userInteractionEnabled = false
        
        titleTextField.text = taskDetail?.title as? String
        detailTextField.text = taskDetail?.detail as? String
        taskTimePicker.date = (taskDetail?.taskTime)!
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteItem(sender: AnyObject) {
        
        /* get data from server */
        NSLog("id ==> %@", (taskDetail?.id)!);
        let deleteurl = taskURL + "/" + ((taskDetail?.id)! as String)
        let url:NSURL = NSURL(string: deleteurl)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "delete"
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
            
            if(res == nil){
                NSLog("No Response!");
            }
            
            let responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
            
            NSLog("Response ==> %@", responseData);
            
            var error: NSError?
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData!, options: []) as? NSDictionary {
                    
                    let success:NSString = jsonResult.valueForKey("message") as! NSString
                    
                    /*if (success != "OK! Events list followed") {
                    NSLog("Get Event Failed")
                    let myAlert = UIAlertController(title: "Access Failed!", message: "Please Log In Again! ", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                    myAlert .dismissViewControllerAnimated(true, completion: nil)
                    self.performSegueWithIdentifier("eventTableToLogin", sender: self)
                    }))
                    presentViewController(myAlert, animated: true, completion: nil)
                    
                    }*/
                    let myAlert = UIAlertController(title: "Delete Task", message: "Are You Sure to Delete This Task? ", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    myAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                        myAlert .dismissViewControllerAnimated(true, completion: nil)
                    }))
                    
                    myAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
                        self.navigationController!.popToRootViewControllerAnimated(true)
                    }))
                    
                    presentViewController(myAlert, animated: true, completion: nil)
                    
                }
            } catch {
                print(error)
            }
            
            
        } else {
            let myAlert = UIAlertController(title: "Connection failed!", message: "urlData Equals to NULL!", preferredStyle: UIAlertControllerStyle.Alert)
            if let error = reponseError {
                myAlert.message = (error.localizedDescription)
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
        
        
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
