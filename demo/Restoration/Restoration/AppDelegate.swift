
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {

        self.window = self.window ?? UIWindow()

        let rvc = RootRestorationVC()
        /// restorationIdentifier 确定视图是否支持状态恢复的标识符。
        /// 该属性指示视图中的状态信息是否应保留;它也用于在恢复过程中识别视图。默认情况下，此属性的值为nil，表示视图的状态不需要保存。将一个字符串对象分配给该属性可以让拥有的视图控制器知道该视图具有要保存的相关状态信息。
        /// 仅当您实现实现encodeRestorableState（with :)和decodeRestorableState（with :)方法来保存和恢复状态的自定义视图时，才为此属性分配值。您可以使用这些方法编写任何特定于视图的状态信息，然后使用该数据将视图还原到其以前的配置。
        /// 重要: 只需设置该属性的值就不足以确保视图被保留并恢复。其拥有的视图控制器以及所有视图控制器的父视图控制器也必须具有恢复标识符。
        rvc.restorationIdentifier = "root"
        let nav = UINavigationController(rootViewController:rvc)
        nav.restorationIdentifier = "nav"

        self.window!.rootViewController = nav
        self.window!.backgroundColor = .white
        self.window!.restorationIdentifier = "window"
        self.window!.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        print("app should restore \(coder)")
        // how to examine the coder
        let key = UIApplicationStateRestorationUserInterfaceIdiomKey
        if let idiomraw = coder.decodeObject(forKey: key) as? Int {
            if let idiom = UIUserInterfaceIdiom(rawValue:idiomraw) {
                if idiom == .phone {
                    print("phone")
                } else {
                    print("pad")
                }
            }
        }
        return true
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        print("app should save \(coder)")
        return true
    }

    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        print("app will encode \(coder)")
    }

    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        print("app did decode \(coder)")
    }

    /*
     func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath ip: [Any], coder: NSCoder) -> UIViewController? {
     print("app delegate \(ip) \(coder)")
     let last = ip.last as! String
     if last == "nav" {
     return self.window!.rootViewController
     }
     if last == "root" {
     return (self.window!.rootViewController as! UINavigationController).viewControllers[0]
     }
     return nil // shouldn't happen; the others all have restoration classes
     }
     */

}
