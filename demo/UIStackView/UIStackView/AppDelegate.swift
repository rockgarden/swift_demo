//
//  AppDelegate.swift
//  UIStackView
//
//  Created by wangkan on 16/9/1.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let frame = self.window!.bounds
        //let vtv = AppStore(frame: frame)
        // Calculator StoryView Timeline Springboard SizeClasses TwiiterProfile Profile
        let vtv = Calculator()
        let nav = UINavigationController(rootViewController: vtv)
        // let sBoard = UIStoryboard(name: "Main", bundle: nil)
        // "TableSimple" -- table search simaple
        // "RJExpandTable" -- expand table simple
        // "DynamicTable" -- sections expand
        // "MasterViewController" -- Table With Dynamic Type
        // let vController: UIViewController = sBoard.instantiateViewControllerWithIdentifier("DynamicTable")
        self.window!.rootViewController = nav
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }
    
}

