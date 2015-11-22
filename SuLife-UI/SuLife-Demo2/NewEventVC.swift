//
//  NewEventVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/16/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit



class NewEventVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    var startDate : NSString = ""
    var endDate : NSString = ""
    
    // var startDate = NSDate()
    // var endDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        endTimePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view.
        
        startTime.text = NSDateFormatter.localizedStringFromDate(startTimePicker.date, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        endTime.text = NSDateFormatter.localizedStringFromDate(endTimePicker.date, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
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
        } else if textField == self.detailTextField {
            self.locationTextField.becomeFirstResponder()
        } else if textField == self.locationTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == locationTextField) {
            scrollView.setContentOffset(CGPoint(x: 0,y: 120), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
     // Mark : Text field END
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePickerValueChanged (datePicker: UIDatePicker) {
        
        startTime.text = NSDateFormatter.localizedStringFromDate(startTimePicker.date, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)

        endTime.text = NSDateFormatter.localizedStringFromDate(endTimePicker.date, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
    
    
    @IBAction func addEventTapped(sender: UIButton) {
        
        // TODO SERVER
        
        // Get title and detail from input
        let eventTitle = titleTextField.text!
        let eventDetail = detailTextField.text!
        
        // Get date from input and convert format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        startDate = dateFormatter.stringFromDate(startTimePicker.date)
        endDate = dateFormatter.stringFromDate(endTimePicker.date)
        
        // Post to server
        let post:NSString = "title=\(eventTitle)&detail=\(eventDetail)&starttime=\(startDate)&endtime=\(endDate)"
        
        NSLog("PostData: %@",post);
        
        let url:NSURL = NSURL(string: eventURL)!
        
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
                        
                        let success:NSString = jsonResult.valueForKey("message") as! NSString
                        
                        if (success == "OK!") {
                            NSLog("Add Event Successfully")
                            
                            //var eventToken = jsonResult.valueForKey("Event") as! NSString as String
                            self.navigationController!.popToRootViewControllerAnimated(true)
                            
                        } else {
                            let myAlert = UIAlertController(title: "Add New Event Failed!", message: "Please Try Again!", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            myAlert.addAction(okAction)
                            self.presentViewController(myAlert, animated:true, completion:nil)
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                let myAlert = UIAlertController(title: "Add New Event Failed!", message: "System Error!", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated:true, completion:nil)
            }
            
        } else {
            let myAlert = UIAlertController(title: "Add New Event Failed!", message: "Response Error!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated:true, completion:nil)
        }
    }
}
