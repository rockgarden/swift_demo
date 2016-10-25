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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //FIXME: 如何执行 "If your app is already in the foreground, iOS does not show the notification."
    /**
     Note from https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html:
     */
    func testUILocalNotification() {
        let notification = UILocalNotification()
        notification.fireDate = Date().addingTimeInterval(10)
        notification.alertBody = "Alert"
        UIApplication.shared.scheduleLocalNotification(notification)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n"){
            textField.resignFirstResponder()
            return false
        } else{
            return true
        } }
    
    func keyboardWillAppear(_ notification: Foundation.Notification) {
        print("Show Keyboard")
    }
    
    func keyboardWillDisappear(_ notification:Foundation.Notification){
        print("Hide Keyboard")
    }
    
    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlternate" {
            if let dest = segue.destination as? FlipsideViewController {
                dest.delegate = self
            }
        }
    }
}

