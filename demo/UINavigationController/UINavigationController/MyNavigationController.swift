
import UIKit

class MyNavigationController: UINavigationController, UINavigationControllerDelegate {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }

    override var shouldAutorotate : Bool {
        return topViewController?.shouldAutorotate ?? false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? [.portrait]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
}


extension MyNavigationController {

    /*
     在 child viewControllers 中若是自定义返回按钮, 则会导致返回手势会失效, 需要在viewDidLoad 中加入
     self.navigationController.interactivePopGestureRecognizer.delegate = self
     这又将导致, 返回手势 执行时 navBar 层级错乱, 好的办法是在, navigationController 中
     delegate = self // 实现 UINavigationControllerDelegate
     后在 代理方法中 当返回到 viewControllers[0] 时禁用 interactivePopGestureRecognizer
    */
    
    /// didShow
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = viewControllers.count > 1
        debugPrint(viewControllers, viewControllers.count)
    }
    
    /*
     App—>RootViewController—>UINavigationController—>UIViewController
     当UINavigationController 作为 child viewController 加入 rootViewController (UITabViewController), 则会导致 UINavigationController 加载的第一个 viewController 不执行 viewWillAppear.
     将UINavigationController作为subview添加到了其他viewController的view中, 或者把UINavigationController添加到UITabbarController中了; 此时，UINavigationController的stack里面的viewController 将收不到 viewWillAppear 等4个方法的调用?
     建议在 RootViewController 中处理
     */
    /// willShow
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(false)
    }
}


// MARK: - UIGestureRecognizerDelegate
extension MyNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

}
