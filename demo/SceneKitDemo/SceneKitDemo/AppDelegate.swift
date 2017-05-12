//
//  AppDelegate.swift
//  SceneKitDemo
//
//  Created by wangkan on 2017/5/12.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.lightGray
        
        let navController = UINavigationController(rootViewController: ViewController())
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        return true
    }

}

