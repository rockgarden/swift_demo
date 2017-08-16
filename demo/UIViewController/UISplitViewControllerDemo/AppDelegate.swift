//
//  AppDelegate.swift
//  UISplitViewControllerDemo
//
//  Created by wangkan on 2017/8/16.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var didChooseDetail = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = self.window ?? UIWindow()

        /// Start from Storyboard
        //let svc = window!.rootViewController as! UISplitViewController
        //svc.delegate = self
        //        
        //let nvc = svc.viewControllers[svc.viewControllers.count-1] as! UINavigationController
        //nvc.topViewController!.navigationItem.leftBarButtonItem = svc.displayModeButtonItem

        let svc = UISplitViewController()
        svc.delegate = self
        let master = MasterViewController()
        master.title = "Pep"
        let nav1 = UINavigationController(rootViewController:master)
        let detail = DetailViewController()
        let nav2 = UINavigationController(rootViewController:detail)
        svc.viewControllers = [nav1, nav2]
        self.window!.rootViewController = svc
        let b = svc.displayModeButtonItem
        detail.navigationItem.leftBarButtonItem = b
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()

        //        let tc = UIScreen.main.traitCollection
        //        if tc.horizontalSizeClass == .Regular {
        //            self.didExpand = true
        //        }

        return true
    }
}


// MARK: - Split view
extension AppDelegate : UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, separateSecondaryFrom vc1: UIViewController) -> UIViewController? {
        print("expanding")
        return nil
    }
    func splitViewController(_ svc: UISplitViewController, collapseSecondary vc2: UIViewController, onto vc1: UIViewController) -> Bool {
        print("collapsing")
        return !self.didChooseDetail
    }

    /// Start from Storyboard: - Split view

    //    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
    //        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
    //        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
    //        if topAsDetailController.detailItem == nil {
    //            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
    //            return true
    //        }
    //        return false
    //    }
}

