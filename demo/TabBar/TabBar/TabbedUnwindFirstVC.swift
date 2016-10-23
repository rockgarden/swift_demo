import UIKit

/*
 Showing how iOS 9 performs a complex unwind involving multiple parent view controllers.
 In the first tab, do a push.
 Switch to the second tab. Do a present.
 Now unwind. We successfully unwind all the way back to the first tab!
 So the second tab dismisses, the tab controller switches to the first tab, and the first tab nav controller pops.
 How on earth is this possible?! There's no code at all (except for the unwind-to-here marker), but the right thing happens.

 Logging reveals the sequence:

 // prelude: source gets a chance to veto the whole thing
 ExtraViewController shouldPerformSegueWithIdentifier(_:sender:) true

 // === first we establish the path from the source to the destination
 // === we also establish _who_ is the destination; note that we only ask "can perform" if you have no eligible children
 // (makes perfect sense: having eligible children already means "it's not me")

 // I have no children and it isn't me
 SecondViewController allowedChildViewControllersForUnwindingFromSource []
 SecondViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) false

 // I have no children and it isn't me
 This one looks like a bug to me: why do we go _down_ into a child when we were told there were no eligible children?
 ExtraViewController allowedChildViewControllersForUnwindingFromSource []
 ExtraViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) false

 // I have one! it's the nav controller in the first tab
 MyTabBarController allowedChildViewControllersForUnwindingFromSource [<TabbedUnwind.MyNavController: 0x7fbb5c817600>]

 // I have two!
 MyNavController allowedChildViewControllersForUnwindingFromSource [<TabbedUnwind.ExtraViewController: 0x7fbb5bc0b4d0>, <TabbedUnwind.FirstViewController: 0x7fbb5bd13e00>]

 // I have no children and it isn't me
 ExtraViewController allowedChildViewControllersForUnwindingFromSource []
 ExtraViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) false

 I have no children and it _is_ me!
 FirstViewController allowedChildViewControllersForUnwindingFromSource []
 FirstViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) true

 // === we have now established the path; now we perform the unwind in stages
 // === note that MyTabBarController is told to unwind to the nav controller; the nav controller is told to unwind to the root vc

 FirstViewController iAmFirst // the marker method is called

 MyTabBarController dismissViewControllerAnimated(_:completion:)

 MyTabBarController unwindForSegue(_:towardsViewController:) <TabbedUnwind.MyNavController: 0x7fbb5c817600>

 MyNavController unwindForSegue(_:towardsViewController:) <TabbedUnwind.FirstViewController: 0x7fbb5bd13e00>

 */

class TabbedUnwindFirstVC: UIViewController {

    /// Step: 8 
    // @IBAction,是UnwindSegue的入口
    // 若只有一个unwind处理函数, 在生成UnwindSegue就不需要选择了对应的@IBAction,所以不弹出菜单
    @IBAction func iAmFirst (_ sender: UIStoryboardSegue!) {
        print("\(type(of: self)) \(#function)")
    }

    // Step 5
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of: self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    // Step 6
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
        if identifier == "UnwindFirst" {
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

