//
//  ViewController.swift
//  UIAlertController
//
//  Created by wangkan on 16/8/19.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
     UIAlertController 要去掉 title view 需要传入两个: nil title: nil, message: nil
     */
    
    @IBAction func actionAlert(sender: AnyObject) {
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle:UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
    }
    
    @IBAction func actionSheet(sender: AnyObject) {
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle:UIAlertControllerStyle.ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
    }
    
    @IBAction func actionAlertWithForm(sender: AnyObject) {
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle:UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        alertController.addTextFieldWithConfigurationHandler({(textField : UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        self.presentViewController(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
    }

}

