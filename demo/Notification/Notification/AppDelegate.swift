//
//  AppDelegate.swift
//  Notification
//
//  Created by wangkan on 16/8/19.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types:([UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge]) , categories: nil))

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cardTapped),
                                               name: NSNotification.Name(rawValue: "cardTapped"),
                                               object: nil)

        return true
    }

    func cardTapped(_ n:Notification) {
        print("card tapped: \(String(describing: n.object))")
    }


    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let notification = UILocalNotification()
        notification.alertBody = "App closed"
        notification.alertAction = "Open"
        application.presentLocalNotificationNow(notification)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

