//
//  KeyboardAccessoryVC.swift
//  TextView
//


import UIKit

class KeyboardAccessoryVC: UIViewController {

    @IBOutlet var textFields : [UITextField]!
    var fr: UIResponder!
    var accessoryView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // configure accessory view
        let arr = UINib(nibName:"KeyboardAccessoryView", bundle:nil).instantiate(withOwner:nil)
        self.accessoryView = arr[0] as! UIView
        let b = self.accessoryView.subviews[0] as! UIButton
        b.addTarget(self, action:#selector(doNextButton), for:.touchUpInside)

        for tf in self.textFields {
            if #available(iOS 10.0, *) {
                tf.textContentType = .emailAddress
            } else {
                // Fallback on earlier versions
            }
        }
    }

    func textFieldDidBeginEditing(_ tf: UITextField) {
        self.fr = tf //keep track of first responder
        tf.inputAccessoryView = self.accessoryView
        tf.keyboardAppearance = .dark
    }

    func textFieldShouldReturn(_ tf: UITextField) -> Bool {
        self.fr = nil
        tf.resignFirstResponder()
        return true
    }

    func doNextButton(_ sender: Any) {
        var ix = self.textFields.index(of:fr as! UITextField)!
        ix = (ix + 1) % textFields.count
        let v = self.textFields[ix]
        v.becomeFirstResponder()
    }

}

