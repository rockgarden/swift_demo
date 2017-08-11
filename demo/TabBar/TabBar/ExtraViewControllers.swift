// iOS9 Storyboard unwind segue反回传递事件时机详细步骤

import UIKit

class ExtraViewController: BaseExtraVC {
    
    deinit {
        print("farewell from ExtraViewController")
    }

}


class ExtraViewController2: BaseExtraVC {

    static let UnwindSegue = "UnwindSecond"
    fileprivate(set) var parameter: String!

    @IBAction func buttonPressed(_ sender: AnyObject) {
        setParameter("Hello Second")
    }

    fileprivate func setParameter(_ para: String) {
        parameter = para
        performSegue(withIdentifier: ExtraViewController2.UnwindSegue, sender: nil)
    }

    // Step 12
    deinit {
        print("farewell from ExtraViewController2")
    }

}


class BaseExtraVC: UIViewController {

    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of: self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    // step 2
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        print("\(type(of: self)) \(#function)")
        super.dismiss(animated: flag, completion: completion)
    }

    /// Step 1
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "UnwindSecond" {
            print("\(type(of: self)) \(#function) \(result)")
        }
        return result
    }

    // Step 7
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindSecond" {
            print("\(type(of: self)) \(#function)")
        }
    }
    
}

