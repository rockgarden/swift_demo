import UIKit

class TabbedUnwindSecondVC: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    @IBAction func iAmSecond (_ sender: UIStoryboardSegue!) {
        print("\(type(of: self)) \(#function)")
        if sender.identifier == ExtraViewController2.UnwindSegue {
            resultLabel.text = (sender.source as! ExtraViewController2).parameter
        }
    }

    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of: self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        print("\(type(of: self)) \(#function)")
        super.dismiss(animated: flag, completion: completion)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(type(of: self)) \(#function) \(result)")
        }
        return result
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(type(of: self)) \(#function)")
        }
    }
    
}

