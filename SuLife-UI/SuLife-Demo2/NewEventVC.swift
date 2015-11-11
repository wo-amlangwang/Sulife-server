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
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    var startDate : NSString = ""
    var endDate : NSString = ""
    
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
       // var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
       // var eventList: NSMutableArray? = userDefaults.objectForKey("eventList") as? NSMutableArray
        
        // Get title and detail from input
        let eventTitle = titleTextField.text!
        let eventDetail = detailTextField.text!
        

        //var dataSet:NSMutableDictionary = NSMutableDictionary()
        //dataSet.setObject(eventTitle, forKey: "eventTitle")
        //dataSet.setObject(eventDetail, forKey: "eventDetail")
        //dataSet.setObject(eventStart, forKey: "eventStartTime")
        //dataSet.setObject(eventEnd, forKey: "eventEndTime")
        
        //let post:NSString = "title=\(eventTitle)&detail=\(eventDetail)&starttime=\(eventStart)&endtime=\(eventEnd)"

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
                
                
                
                //[jsonData[@"success"] integerValue];
                
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
