

import UIKit


class MasterNavigationViewController : UINavigationController {
    // logging to show how things work
    // the segue sends showDetailViewController
    // by way of "target for"
    // the split view controller implements it, it gets the call...
    
    // when it is expanded, it just shoves the detail view controller into the detail slot
    // but when it is collapsed,
    // it turns around and sends showViewController to the nav controller in the primary!
    // thus it gets pushed onto the stack
    
    override func show(_ vc: UIViewController, sender: Any?) {
        print("master NAV view controller showViewController: \(vc)")
        super.show(vc, sender: sender)
        delay(1) {
            print(self.viewControllers)
        }
    }
    
    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        print("master NAV view controller target for \(action) \(String(describing: sender))...")
        let result = super.targetViewController(forAction: action, sender: sender)
        print("master NAV view controller target for \(action), returning \(String(describing: result))")
        return result
    }
    
    override var prefersStatusBarHidden : Bool {
        return true // no effect
    }
    
    override func responds(to aSelector: Selector) -> Bool {
        let ok = super.responds(to:aSelector)
        if aSelector == #selector(showDetailViewController) {
            print("master NAV responds? \(ok)")
        }
        return ok
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let ok = super.canPerformAction(action, withSender:sender)
        if action == #selector(showDetailViewController) {
            print("master NAV can perform? \(ok)")
        }
        return ok
    }
}
