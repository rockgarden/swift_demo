//
//  ViewController.swift
//  UIAlertController
//
//  Created by wangkan on 16/8/19.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class UIAlertControllerVC: UIViewController, UIPopoverPresentationController {

    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet var toolbar : UIToolbar!
    @IBOutlet weak var showPopoverButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
     @IBOutlet weak var log: UILongPressGestureRecognizer!
     UIAlertController 要去掉 title view 需要传入两个: nil title: nil, message: nil
     */
    
    @IBAction func actionAlert(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
    }

    @IBAction func doAlertView(_ sender: Any) {
        let alert = UIAlertController(title: "Not So Fast!",
                                      message: "Do you really want to do this " +
            "tremendously destructive thing?",
                                      preferredStyle: .alert)
        // no delegate needed merely to catch which button was tapped;
        // a UIAlertAction has a handler
        // here's a general handler (though none is needed if you want to ignore)
        func handler(_ act:UIAlertAction!) {
            print("User tapped \(act.title)")
        }
        // illustrating the three button styles
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: handler))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: handler))
        alert.addAction(UIAlertAction(title: "Maybe", style: .default, handler: handler))
        // the last default one is bold in any case
        // but new in iOS 9, seems to boldify the designated button title instead
        alert.preferredAction = alert.actions[2]

        self.present(alert, animated: true)
        // dismissal is automatic when a button is tapped
    }
    
    @IBAction func actionSheet(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
        /// iPad 必须用 popoverPresentationController 否则crash
        if let pop = alertController.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }

    @IBAction func doActionSheet(_ sender: Any) {
        let action = UIAlertController(title: "Choose New Layout", message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in print("Cancel")}))
        func handler(_ act:UIAlertAction) {
            print(act.title as Any)
        }
        for s in ["3 by 3", "4 by 3", "4 by 4", "5 by 4", "5 by 5"] {
            action.addAction(UIAlertAction(title: s, style: .default, handler: handler))
        }
        // action.view.tintColor = .yellow
        self.present(action, animated: true)
        if let pop = action.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }

    @IBAction func actionAlertWithForm(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("you have pressed the Cancel button");
        }
        alertController.addAction(cancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("you have pressed OK button");
        }
        alertController.addAction(OKAction)
        alertController.addTextField(configurationHandler: {(textField : UITextField!) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })
        self.present(alertController, animated: true, completion:{ () -> Void in
            //your code here
        })
    }

    @IBAction func doAlertViewAddTextField(_ sender: Any) {
        let alert = UIAlertController(title: "Enter a number:", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.keyboardType = .numberPad // ??? not on iPad
            tf.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        }
        func handler(_ act:UIAlertAction) {
            // it's a closure so we have a reference to the alert
            let tf = alert.textFields![0]
            print("User entered \(tf.text), tapped \(act.title)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        alert.actions[1].isEnabled = false
        self.present(alert, animated: true)
    }

    func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        // enable OK button only if there is text
        // hold my beer and watch this: how to get a reference to the alert
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[1].isEnabled = (tf.text != "")
    }

    //MARK: - toolbar action
    @IBAction func doButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        func handler(_ act:UIAlertAction!) {
            print("User tapped \(act.title)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handler)) // not shown
        alert.addAction(UIAlertAction(title: "Hey", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Ho", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey Nonny No", style: .default, handler: handler))
        self.present(alert, animated: true)
        // if we do no more than that, we'll crash with a helpful error message:
        // "UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs"
        // so the runtime knows that on iPad this should be a popover, and has arranged it already
        // all we have to do is fulfill our usual popover responsibilities
        // return;
        if let pop = alert.popoverPresentationController {
            let b = sender as! UIBarButtonItem
            pop.barButtonItem = b
            //FIXME: iPad 上 b 消失了
            // but now we have the usual foo where we must prevent the bar button items from being "live"; why isn't this automatic???
            // still, it isn't anywhere near as bad as in previous systems
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }

    @IBAction func doOtherThing(_ sender: Any) {
        let pvc = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
        pvc.modalPresentationStyle = .popover
        self.present(pvc, animated: true)
        if let pop = pvc.popoverPresentationController {
            let b = sender as! UIBarButtonItem
            pop.barButtonItem = b
            pop.delegate = self
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }
    
    @IBAction func showPopover(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PopoverVC", bundle: nil)
        let pc = storyboard.instantiateViewController(withIdentifier: "Popover") as? PopoverVC
        pc?.modalPresentationStyle = .popover
        
        let popoverViewController = pc!.popoverPresentationController
        popoverViewController?.permittedArrowDirections = .any
        popoverViewController?.delegate = self
        popoverViewController?.sourceView = self.showPopoverButton
        popoverViewController?.sourceRect = CGRect(
            x: self.view.bounds.origin.x + 30,
            y: self.view.bounds.origin.y + 10,
            width: 1,
            height: 1)
        present(pc!, animated: true, completion: nil)
    }
    
    @IBAction func showAlertCustomize(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Hello, I'm alert! \n\n\n\n\n\n\n", message: "", preferredStyle: .alert)
        
        let rect        = CGRect(x: 15, y: 50, width: 240, height: 150.0)
        let textView    = UITextView(frame: rect)
        
        textView.font               = UIFont(name: "Helvetica", size: 15)
        textView.textColor          = UIColor.lightGray
        textView.backgroundColor    = UIColor.white
        textView.layer.borderColor  = UIColor.lightGray.cgColor
        textView.layer.borderWidth  = 1.0
        textView.text               = "Enter message here"
        textView.delegate           = self
        
        alertController.view.addSubview(textView)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            let msg = (textView.textColor == UIColor.lightGray) ? "" : textView.text
            
            print(msg as Any)
            
        })
        alertController.addAction(cancel)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: {})
    }

}


// not needed in iOS 8.3 but needed again in iOS 9
extension UIAlertControllerVC: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerShouldDismissPopover(
        _ pop: UIPopoverPresentationController) -> Bool {
        let ok = pop.presentedViewController.presentedViewController == nil
        return ok
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension UIAlertControllerVC: UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


extension UIAlertControllerVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
