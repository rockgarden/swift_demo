

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    /// 解析协议,进行不同的操作,分别跳转到主应用的不同页面,通过OpenUrl方法
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let scheme = url.scheme
        _ = url.host
        if scheme == "coffeetime" {
        }
        return false
    }

}

