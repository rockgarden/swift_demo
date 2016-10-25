import UIKit

// look, ma, no @UIApplicationMain!
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // look, ma, no storyboard!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        self.window!.backgroundColor = UIColor.white
        self.window!.rootViewController =
            MyViewController(nibName:"MyViewController", bundle:nil)
        self.window!.makeKeyAndVisible()
        return true
    }
    
}
