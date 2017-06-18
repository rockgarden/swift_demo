

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: pageControllerRestoration

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    // This time we don't encode any Pep here at all!
    // we just make it possible for Pep to encode itself more or less automatically
    // to do this, first we restore the whole interface;
    // all restorable view controllers already exist, so we just point to them

    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath ip: [Any], coder: NSCoder) -> UIViewController? {
        let last = (ip as NSArray).lastObject as! String
        var result : UIViewController? = nil
        switch last {
        case "pvc":
            result = (self.window!.rootViewController as! UINavigationController).topViewController as! UIPageViewController
        case "pep":
            result = ((self.window!.rootViewController as! UINavigationController).topViewController as! UIPageViewController).viewControllers![0]
        default: break
        }
        print("app delegate providing view controller \(String(describing: result))")
        return result
    }

    // all we really need to save is the current boy name

    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        guard let vc = (self.window!.rootViewController as? UINavigationController)?.topViewController as? UIPageViewController else {return}
        guard let person = vc.viewControllers![0] as? Person else {return}

        print("app delegate encoding \(person)")
        coder.encode(person, forKey:"person")

        let boy = person.boy
        print("app delegate encoding \(boy)")
        coder.encode(boy, forKey:"boy")
    }

    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        print("app delegate decoding...")

        let personMaybe = coder.decodeObject(forKey:"person")
        print("app delegate decoding \(String(describing: personMaybe))")
        guard let person = personMaybe as? Person else {return}

        let boyMaybe = coder.decodeObject(forKey:"boy")
        print("app delegate decoding \(String(describing: boyMaybe))")
        guard let boy = boyMaybe as? String else {return}

        _ = Person(pepBoy: boy)

        guard let vc = (self.window!.rootViewController as? UINavigationController)?.topViewController as? UIPageViewController else {return}

        vc.setViewControllers([person], direction: .forward, animated: false)
    }

}

