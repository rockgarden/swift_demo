
import UIKit
let arr = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth"]
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	var tabBarController = UITabBarController()
	var myDataSource: MyDataSource!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		self.window = UIWindow()

		// to see an interesting bug on iPhone 6 Plus, pick "Eighth", rotate to landscape, rotate back to portrait
		var vcs = [UIViewController]()
		for t in arr {
			let vc = ViewController()
			vc.tabBarItem.title = t
			vcs.append(vc)
		}
		self.tabBarController.viewControllers = vcs
		self.window!.rootViewController = self.tabBarController

		let ok = true
		var customize: Bool { return ok }

		if customize {
			let more = self.tabBarController.moreNavigationController
			let list = more.viewControllers[0]
			list.title = ""
			let b = UIBarButtonItem()
			b.title = "Back"
			list.navigationItem.backBarButtonItem = b // so user can navigation back
			more.navigationBar.barTintColor = UIColor.red
			more.navigationBar.tintColor = UIColor.white
			let tv = list.view as! UITableView
			let mds = MyDataSource(originalDataSource: tv.dataSource!)
			self.myDataSource = mds
			tv.dataSource = mds
		}

		self.window!.backgroundColor = UIColor.white
		self.window!.makeKeyAndVisible()
		return true
	}
}
