//
//  AppDelegate.swift
//  FileOperations
//
//  Created by wangkan on 2016/11/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        print("start \(#function)")
        print(url)


        let finalurl = url

        // work around bug where Quick Look can no longer preview a document in the inbox
        // okay, they seem to have fixed the bug in iOS 9, cutting for now

        /*

         let dir = url.URLByDeletingLastPathComponent?.lastPathComponent
         if dir == "Inbox" {
         do {
         print("inbox")
         let fm = NSFileManager()
         let docsurl = try fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
         let dest = docsurl.URLByAppendingPathComponent(url.lastPathComponent!)
         print("copying")
         try fm.copyItemAtURL(url, toURL: dest)
         finalurl = dest
         print("removing")
         try fm.removeItemAtURL(url)
         } catch {
         print(error)
         }
         }

         */

        let vc = self.window!.rootViewController as! HandoffVC
        vc.displayDoc(finalurl)
        print("end \(#function)")
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("start \(#function)")
        print("end \(#function)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("start \(#function)")
        print("end \(#function)")
    }

    // logging shows that handleOpenURL: comes *between* willEnter and didBecome

}

