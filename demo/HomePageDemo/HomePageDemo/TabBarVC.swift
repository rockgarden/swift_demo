//
//  TabBarVC.swift
//
//  Created by wangkan on 16/8/10.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

	fileprivate var controllers = [(vc: "", title: "", image: "", selectedImage: "")]

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setTabBarVC()
	}

	fileprivate func setTabBarVC() {
		controllers.removeAll()
		let homeA = (vc: NSStringFromClass(HomeVC.self), title: "Pay", image: "first", selectedImage: "first")
		controllers.append(homeA)
		addController()
	}

}


extension TabBarVC {

	fileprivate func addController() {
		guard controllers.count > 0 else {
			debugPrint("error: VC控制器数组controllers为nil")
			return
		}
		var navArray = [UIViewController]()
		for t in controllers {
            let aClass = NSClassFromString(t.vc) as! UIViewController.Type
            let vc = aClass.init()
			let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
			nav.navigationBar.barTintColor = UIColor(hexString: "#595757")
            nav.navigationBar.tintColor = UIColor.white
			nav.tabBarItem = UITabBarItem(title: t.title, image: UIImage(named: t.image), selectedImage: UIImage(named: t.selectedImage))
			navArray.append(nav)
		}
		self.viewControllers = navArray
	}

}


internal extension UIStoryboard {
    class func getViewControllerFromStoryboard(_ vc: String, sb: String) -> UIViewController {
        let sBoard = UIStoryboard(name: sb, bundle: nil)
        let vController: UIViewController = sBoard.instantiateViewController(withIdentifier: vc)
        return vController
    }
}


internal extension UIColor {
    
    internal convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16) / 255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8) / 255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0) / 255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha) } else {
            return nil
        }
    }
    
}

