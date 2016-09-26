//
//  AppDelegate.swift
//  UINavigationController
//
//  Created by wangkan on 2016/9/26.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window!.tintColor = UIColor.orangeColor() // gag... Just proving this is inherited
        
        // nav bar is configured (horribly) in the storyboard
        
        // and now for some even more disgusting decoration
        
        let im = UIImage(named:"linen.png")!
        let sz = CGSizeMake(5,34)
        UIGraphicsBeginImageContextWithOptions(sz, false, 0)
        im.drawAtPoint(CGPointMake(-55,-55))
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let im3 = im2.resizableImageWithCapInsets(UIEdgeInsetsMake(0,0,0,0), resizingMode:.Tile)
        UIBarButtonItem.appearance().setBackgroundImage(im3, forState:.Normal, barMetrics:.Default)
        
        
        // if the back button is assigned a background image, the chevron is removed entirely
        // UIBarButtonItem.appearance().setBackButtonBackgroundImage(im3, forState: .Normal, barMetrics: .Default)
        
        // also, note that if the back button is assigned a background image,
        // it is not vertically resized
        // and if it has an image, that image is resized to fit
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

