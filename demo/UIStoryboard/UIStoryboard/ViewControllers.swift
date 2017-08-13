

import UIKit

/*

 ViewController4 shouldPerformSegueWithIdentifier(_:sender:) true

 ViewController4 allowedChildViewControllersForUnwindingFromSource []
 ViewController4 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController3 allowedChildViewControllersForUnwindingFromSource []
 ViewController3 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController4 allowedChildViewControllersForUnwindingFromSource []
 ViewController4 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController3 allowedChildViewControllersForUnwindingFromSource []
 ViewController3 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController2 allowedChildViewControllersForUnwindingFromSource []
 ViewController2 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController4 allowedChildViewControllersForUnwindingFromSource []
 ViewController4 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController3 allowedChildViewControllersForUnwindingFromSource []
 ViewController3 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController2 allowedChildViewControllersForUnwindingFromSource []
 ViewController2 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
 ViewController1 allowedChildViewControllersForUnwindingFromSource []
 ViewController1 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: true

 ViewController4 prepareForSegue(_:sender:)
 ViewController1 unwind
 ViewController1 dismiss(animated:_:completion:)

 */

/*

 ViewController4 shouldPerformSegue(withIdentifier:sender:) true
 ViewController4 allowedChildViewControllersForUnwinding(from:) []
 ViewController4 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 ViewController3 allowedChildViewControllersForUnwinding(from:) []
 ViewController3 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 ViewController2 allowedChildViewControllersForUnwinding(from:) []
 ViewController2 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 ViewController1 allowedChildViewControllersForUnwinding(from:) []
 ViewController1 canPerformUnwindSegueAction(_:from:withSender:) unwind: true

 ViewController4 prepare(for:sender:)
 ViewController1 unwind
 ViewController1 dismiss(animated:completion:)

 */


class ViewController1: BaseVC {

    @IBAction func unwind (_ sender:UIStoryboardSegue) {
        print("\(type(of:self)) \(#function)")
    }
}


// TODO: 多个Scenc共用
class ViewController2: BaseVC {

    @IBOutlet var lab : UILabel! //不能继承

    override var description : String {
        get {
            if self.lab != nil {
                return "View Controller - \(self.lab.text!)"
            }
            else {
                return super.description
            }
        }
    }

    @IBAction func unwind2(_ segue:UIStoryboardSegue!) {
        print("vc 2 unwind")
    }
}


class ViewController3: ViewController2 {

    @IBAction func unwind3(_ seg:UIStoryboardSegue!) {
        fatalError("view controller 3 unwind should never be called")
    }
}


class ViewController4: BaseVC {}


class UIStoryboardTabBarController: UITabBarController {

    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of:self)) \(#function) \(action) \(result)")
        return result
    }

    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(type(of:self)) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        print("\(identifier) \(type(of:self)) \(#function) \(result)")
        return result
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil {
            print("\(segue.identifier!) \(type(of:self)) \(#function)")
        }
    }

}

class TabChild1: BaseVC {}
class TabChild2: BaseVC {}


class BaseVC: UIViewController {

    override func responds(to aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("\(type(of:self)) is asked if it responds to \(aSelector)")
        }
        let result = super.responds(to: aSelector)
        return result
    }

    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of:self)) \(#function) \(action) \(result)")
        return result
    }

    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(type(of:self)) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(type(of:self)) \(#function) \(result)")
        }
        return result
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(type(of:self)) \(#function)")
        }
    }
}


class UIStoryboardNavigationController : UINavigationController {

    override func responds(to aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("nav controller is asked if it responds to \(aSelector)")
        }
        let result = super.responds(to: aSelector)
        return result
    }

    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of:self)) \(#function) \(action) \(result)")
        return result
    }

    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(type(of:self)) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(type(of:self)) \(#function) \(result)")
        }
        return result
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(type(of:self)) \(#function)")
        }
    }

    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        print("\(type(of:self)) \(#function)")
        return super.popToViewController(viewController, animated:animated)
    }


    /*

     override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: Any!) -> UIViewController? {

     var result : UIViewController? = nil

     print("nav controller's view controller for unwind is called...")
     let which = 1
     switch which {
     case 1:
     let vc = self.viewControllers[0] as! UIViewController
     print("nav controller returns \(vc) from vc for unwind segue")
     result = vc
     case 2:
     let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
     print("nav controller returns \(vc) from vc for unwind segue")
     result = vc
     default: break
     }

     return result
     }


     override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
     print("nav controller was asked for segue")

     // are we in the very specific situation where
     // we are unwinding from vc 3 thru vc 2 to vc 1?

     let vcs = self.viewControllers as! [UIViewController]
     if vcs.count == 2 && toViewController == vcs[0] {
     if fromViewController == self.presented {
     return UIStoryboardSegue(identifier: identifier,
     source: fromViewController,
     destination: toViewController) {
     self.dismiss(animated:true) {
     _ in
     self.popToViewController(
     toViewController, animated: true)
     return // argh, swift!
     }
     }
     }
     }
     return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
     }
     */
}
