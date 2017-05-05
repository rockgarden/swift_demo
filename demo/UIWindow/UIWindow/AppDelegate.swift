//
//  AppDelegate.swift
//  UIWindow
//
//  Created by wangkan on 2016/11/3.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        return MyWindow(frame: UIScreen.main.bounds)
    }()

    var backWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let _back = AppBackVC()
        backWindow = UIWindow(frame: UIScreen.main.bounds)
        backWindow!.rootViewController = _back
        backWindow?.makeKeyAndVisible()

        let _front = AppWindowNavVC(rootViewController: WindowTestVC())
        window!.rootViewController = _front
        window!.makeKeyAndVisible()

        return true
    }

}


private class AppBackVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        let label = UILabel(frame: view.frame)
        label.text = "APP BACK VIEW"
        label.textColor = UIColor.red
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center

        view.addSubview(label)
    }
}
