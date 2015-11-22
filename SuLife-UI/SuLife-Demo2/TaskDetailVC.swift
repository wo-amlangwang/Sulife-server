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
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var timeLable: UILabel!
    
    @IBOutlet weak var undoButton: UIButton!
    
    var taskDetail : TaskModel!
    
    var task:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.userInteractionEnabled = false
        detailTextField.userInteractionEnabled = false
        
        titleTextField.text = taskDetail.title as String
        detailTextField.text = taskDetail.detail as String
        
        timeLable.text = NSDateFormatter.localizedStringFromDate((taskDetail!.taskTime), dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        if (taskDetail?.finish == false) {
            undoButton.hidden = true
        }
    }
    
    @IBAction func deleteItem(sender: AnyObject) {
        /* get data from server */
        NSLog("id ==> %@", (taskDetail?.id)!);
        let deleteurl = taskURL + "/" + ((taskDetail?.id)! as String)
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
                    
                    let myAlert = UIAlertController(title: "Delete task", message: "Are You Sure to Delete This task? ", preferredStyle: UIAlertControllerStyle.Alert)
                    
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
        if (segue?.identifier == "taskToEdittask") {
            let viewController = segue?.destinationViewController as! EditTaskVC
            let id = taskDetail!.id
            let title = taskDetail!.title
            let detail = taskDetail!.detail
            let taskTime = taskDetail!.taskTime
            let finish = taskDetail!.finish
            viewController.taskDetail = TaskModel(title: title, detail: detail, time: taskTime, finish: finish, id: id)
        }
    }
    
    @IBAction func undoMarkTapped(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let title = taskDetail!.title
        let detail = taskDetail!.detail
        let taskTime = dateFormatter.stringFromDate(taskDetail!.taskTime)
        let finished = false
        
        let post:NSString = "title=\(title)&detail=\(detail)&establishTime=\(taskTime)&finished=\(finished)"
        
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
                        
                        let success:NSString = jsonResult.valueForKey("message") as! NSString
                        
                        
                        // Ok ????????
                        if (success != "OK!") {
                            NSLog("Mark Task Failed")
                            let myAlert = UIAlertController(title: "Access Failed!", message: "Please Log In Again! ", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                                myAlert .dismissViewControllerAnimated(true, completion: nil)
                            }))
                            presentViewController(myAlert, animated: true, completion: nil)
                            
                        } else {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
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
}

