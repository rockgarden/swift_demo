//
//  AppDelegate.swift
//  animate
//
//  Created by wangkan on 16/8/18.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        self.window = UIWindow()
//        let sBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vController = sBoard.instantiateViewController(withIdentifier: "CancelAnimation")
//        self.window!.rootViewController = UINavigationController(rootViewController: vController)
//        self.window!.backgroundColor = UIColor.white
//        self.window!.makeKeyAndVisible()
        return true
    }

    
}

