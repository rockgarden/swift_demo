//
//  ShakeMotionVC.swift
//  UIResponder
//

import UIKit

class ShakeMotionVC: UIViewController {
    // shake device (or simulator), watch console for response
    /// note: 不会在文本字段中通过摇动来禁用撤消  that this does not disable Undo by shaking in text field?

    override var canBecomeFirstResponder : Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if self.isFirstResponder {
            print("hey, you shook me!")
        } else {
            super.motionEnded(motion, with: event)
        }
    }

    func textFieldDidEndEditing (_ textField:UITextField) {
        print("end editing")
        self.becomeFirstResponder()
    }

}

