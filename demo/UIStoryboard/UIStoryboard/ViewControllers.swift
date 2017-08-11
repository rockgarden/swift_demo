

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

class ViewController2: BaseVC {}

class ViewController3: BaseVC {}
class ViewController4: BaseVC {}


class MyTabBarController: UITabBarController {

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

class TabChild1: BaseVC {}
class TabChild2: BaseVC {}


class BaseVC: UIViewController {

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

