

import UIKit

/*
 显示如何手动配置一个用于iPad和iPhone的分割视图控制器
 */

/// create and configure split view controller entirely in code, place into interface
class SplitViewControllerManual: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let svc = UISplitViewController()
        svc.viewControllers = [PrimaryViewController(), SecondaryViewController()]
        self.addChildViewController(svc)
        self.view.addSubview(svc.view)
        svc.didMove(toParentViewController: self)

        svc.presentsWithGesture = false
        svc.preferredDisplayMode = .primaryHidden
    }

    // demonstration of how to implement your own logic for targetViewControllerForAction
    // here, we arrange things so that the showHide: message, if it reaches this far the hierarchy,
    // is routed to the Primary view controller if possible
    // In this way, the Secondary can message the Primary completely agnostically!
    // This is the kind of "loose coupling" that Apple is after here

    /// 返回响应该操作的视图控制器。
    /// 该方法返回当前视图控制器，如果该视图控制器覆盖由action参数指示的方法。 如果当前的视图控制器不覆盖该方法，UIKit会向上移动视图层次结构，并返回第一个视图控制器来覆盖它。 如果没有视图控制器处理该操作，则此方法返回nil。
    /// 视图控制器可以通过从其canPerformAction（_：withSender :)方法返回适当的值来选择性地响应动作。
    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        if action == #selector(showHide) {
            let svc = self.childViewControllers[0] as! UISplitViewController
            let primary = svc.viewControllers[0]
            if primary.canPerformAction(action, withSender: sender) {
                return primary
            }
        }
        return super.targetViewController(forAction:action, sender: sender)
    }
}

