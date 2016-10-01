//
//  AppDelegate.swift
//  TableView
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow()
        let sBoard = UIStoryboard(name: "Main", bundle: nil)
        // "UISearchControllerVC" -- table search simaple
        // "RJExpandTable" -- expand table simple
        // "DynamicTable" -- sections expand
        // "MasterViewController" -- Table With Dynamic Type
        let vController: UIViewController = sBoard.instantiateViewControllerWithIdentifier("UISearchControllerVC")
        self.window!.rootViewController = UINavigationController(rootViewController: vController)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}

