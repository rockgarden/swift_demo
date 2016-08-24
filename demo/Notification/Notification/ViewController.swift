//
//  ViewController.swift
//  Notification
//
//  Created by wangkan on 16/8/19.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FlipsideViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    //FIXME: 如何执行 "If your app is already in the foreground, iOS does not show the notification."
    /**
     Note from https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html:
     */
    func testUILocalNotification() {
        let notification = UILocalNotification()
        notification.fireDate = NSDate().dateByAddingTimeInterval(10)
        notification.alertBody = "Alert"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n"){
            textField.resignFirstResponder()
            return false
        } else{
            return true
        } }
    
    func keyboardWillAppear(notification: NSNotification) {
        print("Show Keyboard")
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        print("Hide Keyboard")
    }
    
    func flipsideViewControllerDidFinish(controller:FlipsideViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAlternate" {
            if let dest = segue.destinationViewController as? FlipsideViewController {
                dest.delegate = self
            }
        }
    }
}

