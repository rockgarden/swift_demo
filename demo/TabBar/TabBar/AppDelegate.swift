
import UIKit

fileprivate let arr = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth"]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	var tabBarController = UITabBarController()
	var myDataSource: MyDataSource!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //exampleTabUnwind()
        //exampleNoController()
        exampleCodeInit()
        //setTabBar()
        /// no func run Main.storyboard
		return true
	}

    // 示例 Unwind UIViewController
    func exampleTabUnwind() {
        self.window = UIWindow()
        let sBoard = UIStoryboard(name: "TabbedUnwind", bundle: nil)
        let vController = sBoard.instantiateViewController(withIdentifier: "MyTabBarController")
        self.window!.rootViewController = vController //UINavigationController()会导致第二层的UINavigationController的Back Button 消失 
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
    }

    /// 示例 subClass UIViewController
    func exampleNoController() {
        self.window = UIWindow()
        let sBoard = UIStoryboard(name: "TabViewController", bundle: nil)
        let vController = sBoard.instantiateViewController(withIdentifier: "TabViewController")
        self.window!.rootViewController = vController
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
    }

    /// 示例 init UITabBarController by code
    func exampleCodeInit() {
        self.window = self.window ?? UIWindow()
        var vcs = [UIViewController]()
        for t in arr {
            let vc = SubVC()
            vc.tabBarItem.title = t
            vcs.append(vc)
        }
        self.tabBarController.viewControllers = vcs
        self.window!.rootViewController = self.tabBarController
        let ok = true
        var customize: Bool { return ok }

        ///FIXME:这是什么鬼?
        doneCustomizing:
        if customize {
            let more = self.tabBarController.moreNavigationController
            let list = more.viewControllers[0]
            list.title = ""
            let b = UIBarButtonItem()
            b.title = "Back"
            list.navigationItem.backBarButtonItem = b //so user can navigation back
            more.navigationBar.barTintColor = UIColor.red
            more.navigationBar.tintColor = UIColor.white
            // break doneCustomizing

            let tv = list.view as! UITableView
            let mds = MyDataSource(originalDataSource: tv.dataSource!)
            self.myDataSource = mds
            tv.dataSource = mds
        }
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
    }

    // 配置 appearance
    func setTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName:UIFont(name:"Avenir-Heavy", size:14)!
            ],for: UIControlState())
        // UIFont.familyNames().map{UIFont.fontNamesForFamilyName($0 as String)}.map(println)
        let ding = UIFont(name:"ZapfDingbatsITC", size: 16)!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 60,height: 40), false, 0)
        let s = "\u{2713}"
        let p = NSMutableParagraphStyle()
        p.alignment = .right
        s.draw(in: CGRect(x: 0, y: 0,width: 60, height: 40),
               withAttributes:[
                NSFontAttributeName:ding,
                NSParagraphStyleAttributeName:p,
                NSForegroundColorAttributeName:UIColor.red])
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UITabBar.appearance().selectionIndicatorImage = im
    }
}

class MyTabBarController: UITabBarController {
    /// Step 3
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }

    // Step 10
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of: self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }

    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }

    // Step 9
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        print("\(type(of: self)) \(#function)")
        super.dismiss(animated: flag, completion: completion)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\(type(of: self)) \(#function)")
    }
}

class MyNavController: UINavigationController {
    // Step 4
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of: self)) \(#function) \(result)")
        return result
    }

    // Step 11
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

func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}
