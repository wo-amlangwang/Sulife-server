//
//  ContactDetailVC.swift
//  SuLife-Demo2
//
//  Created by Sine Feng on 11/12/15.
//  Copyright © 2015 Sine Feng. All rights reserved.
//

import UIKit

class ContactDetailVC: UIViewController {

    @IBOutlet weak var firstNameTextView: UITextView!
    @IBOutlet weak var lastNameTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    
    var contactDetail : ContactsModel?
    //var contact : NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstNameTextView.userInteractionEnabled = false
        lastNameTextView.userInteractionEnabled = false
        emailTextView.userInteractionEnabled = false
        
        firstNameTextView.text = contactDetail?.firstName as? String
        lastNameTextView.text = contactDetail?.lastName as? String
        emailTextView.text = contactDetail?.email as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteContactTapped(sender: UIButton) {
        
        /* get data from server */
        let deleteurl = deleteContactURL + "/" + ((contactDetail?.id)! as String)
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
                    
                    let myAlert = UIAlertController(title: "Delete Contact", message: "Are You Sure to Delete This Contact? ", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    myAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                        myAlert .dismissViewControllerAnimated(true, completion: nil)
                    }))
                    
                    myAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
                        self.navigationController!.popViewControllerAnimated(true)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue?.identifier == "showSharedEvents") {
            let vc = segue?.destinationViewController as! SharedEventsTVC
                
            let firstname = contactDetail!.firstName
            let lastname = contactDetail!.lastName
            let email = contactDetail!.email
            let userid = contactDetail!.id
            vc.contactDetail = ContactsModel(firstName: firstname, lastName: lastname, email: email, id: userid)
        }
    }
}
