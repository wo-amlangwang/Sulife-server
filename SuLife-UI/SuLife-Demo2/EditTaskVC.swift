//
//  EditTaskVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/13/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class EditTaskVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    
    @IBOutlet weak var taskTimePicker: UIDatePicker!
    
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var taskTime : NSString = ""
    
    var taskDetail : TaskModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.text = taskDetail!.title as String
        detailTextField.text = taskDetail!.detail as String
        
        taskTimePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        timeLable.text = NSDateFormatter.localizedStringFromDate((taskDetail!.taskTime), dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)

        // Tab The blank place, close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard () {
        view.endEditing(true)
    }
    
    
    // Mark : Text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.detailTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == detailTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 20), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    // Mark : Text field END
    
    // MARK : Ask if save before back
    
    /*override func viewDidDisappear(animated: Bool) {
        if self.isMovingToParentViewController() {
            let myAlert = UIAlertController(title: "Alert", message: "Leave without saving?", preferredStyle: UIAlertControllerStyle.Alert)
            
            myAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                myAlert .dismissViewControllerAnimated(true, completion: nil)
            }))
            
            myAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action: UIAlertAction!) in
                self.saveAction()
            }))
            
            presentViewController(myAlert, animated: true, completion: nil)
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerValueChanged (datePicker: UIDatePicker) {
        
        timeLable.text = NSDateFormatter.localizedStringFromDate(taskTimePicker.date, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }

    @IBAction func saveButtonTapped(sender: UIButton) {
        saveAction()
    }
    
    func saveAction () {
        let title = titleTextField.text!
        let detail = detailTextField.text!
        
        if (title.isEmpty || detail.isEmpty) {
            let myAlert = UIAlertController(title: "Edit Task Failed!", message: "All fields required!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
            return
        }

        
        // Get date from input and convert format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        taskTime = dateFormatter.stringFromDate(taskTimePicker.date)
        
        // Post to server
        let post:NSString = "title=\(title)&detail=\(detail)&establishTime=\(taskTime)"
        
        NSLog("PostData: %@",post);
        
        let edittaskURL = taskURL + "/" + (taskDetail!.id as String)
        let url:NSURL = NSURL(string: edittaskURL)!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
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
                        
                        //var taskToken = jsonResult.valueForKey("task") as! NSString as String
                        self.navigationController!.popToRootViewControllerAnimated(true)
                    }
                } catch {
                    print(error)
                }
            } else {
                let myAlert = UIAlertController(title: "Edit task Failed!", message: "System Error!", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
            
        } else {
            let myAlert = UIAlertController(title: "Edit task Failed!", message: "Response Error!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        titleTextField.resignFirstResponder();
        detailTextField.resignFirstResponder();
    }
}
