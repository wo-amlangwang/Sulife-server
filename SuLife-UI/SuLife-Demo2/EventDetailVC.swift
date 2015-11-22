//
//  EventDetailVC.swift
//  SuLife
//
//  Created by Sine Feng on 10/16/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextView!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var startTime: UITextView!
    @IBOutlet weak var endTime: UITextView!

    
    var eventDetail : EventModel?
    
    var event:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.userInteractionEnabled = false
        detailTextField.userInteractionEnabled = false
        startTime.userInteractionEnabled = false
        endTime.userInteractionEnabled = false
        
        
        titleTextField.text = eventDetail?.title as? String
        detailTextField.text = eventDetail?.detail as? String
        
        startTime.text = NSDateFormatter.localizedStringFromDate((eventDetail?.startTime)!, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        endTime.text = NSDateFormatter.localizedStringFromDate((eventDetail?.endTime)!, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func deleteItem(sender: AnyObject) {
        /* get data from server */
        NSLog("id ==> %@", (eventDetail?.id)!);
        let deleteurl = eventURL + "/" + ((eventDetail?.id)! as String)
        let url:NSURL = NSURL(string: deleteurl)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "delete"
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
                    
                    let myAlert = UIAlertController(title: "Delete Event", message: "Are You Sure to Delete This Event? ", preferredStyle: UIAlertControllerStyle.Alert)
                    
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue?.identifier == "eventToEditEvent") {
            let viewController = segue?.destinationViewController as! EditEventVC
            let id = eventDetail!.id
            let title = eventDetail!.title
            let detail = eventDetail!.detail
            let startTime = eventDetail!.startTime
            let endTime = eventDetail!.endTime
            let share = eventDetail!.share
            viewController.eventDetail = EventModel(title: title, detail: detail, startTime: startTime, endTime: endTime, id: id, share: share)
        }
    }
    
}
