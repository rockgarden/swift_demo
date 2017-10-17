//
//  AppDelegate.swift
//  MediaPlayerDemo
//
//  Created by wangkan on 2016/12/9.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timer : Timer?

    // standard behavior: category is ambient, activate on app activate and after interruption ends
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        /// 预先检查 new in iOS 9, can check beforehand
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)

        // deliberate leak here
        NotificationCenter.default.addObserver(forName:.AVAudioSessionRouteChange, object: nil, queue: nil) { n in
            NSLog("change route %@", n.userInfo!)
            print("current route \(AVAudioSession.sharedInstance().currentRoute)")
        }

        // properly, if the route changes from some kind of Headphones to Built-In Speaker,
        // we should pause our sound (doesn't happen automatically)
        NotificationCenter.default.addObserver(forName:
        .AVAudioSessionInterruption, object: nil, queue: nil) { n in
            let why = n.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
            let type = AVAudioSessionInterruptionType(rawValue: why)!
            //            switch type {
            //            case .began:
            //                print("interruption began:\n\(n.userInfo!)")
            //            case .ended:
            //                print("interruption ended:\n\(n.userInfo!)")
            //                try? AVAudioSession.sharedInstance().setActive(true)
            //                guard (n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt) != nil else {return}
            //            }
            if type == .began {
                print("interruption began:\n\(n.userInfo!)")
            }
            if type == .ended {
                print("interruption ended:\n\(n.userInfo!)")
                guard let opt = n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt else {return}
                if AVAudioSessionInterruptionOptions(rawValue:opt).contains(.shouldResume) {
                    print("should resume")
                } else {
                    print("not should resume")
                }
                try? AVAudioSession.sharedInstance().setActive(true)
            }
        }

        // use control center to test, e.g. start and stop a Music song
        NotificationCenter.default.addObserver(forName:
        .AVAudioSessionSilenceSecondaryAudioHint, object: nil, queue: nil) { n in
            let why = AVAudioSessionSilenceSecondaryAudioHintType(rawValue: n.userInfo![AVAudioSessionSilenceSecondaryAudioHintTypeKey] as! UInt)!
            if why == .begin {
                print("silence hint begin:\n\(n.userInfo!)")
            } else {
                print("silence hint end:\n\(n.userInfo!)")
            }
        }


        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)

        NotificationCenter.default.addObserver(forName:
        .MPMediaLibraryDidChange, object: nil, queue: nil) { _ in
            print("library changed!")
            print("library last modified \(MPMediaLibrary.default().lastModifiedDate)")
        }

        /// NB this will trigger the authorization dialog
        checkForMusicLibraryAccess {
            MPMediaLibrary.default().beginGeneratingLibraryChangeNotifications()
            print("library last modified \(MPMediaLibrary.default().lastModifiedDate)")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("bp in \(#function)")
        self.timer = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(fired), userInfo: nil, repeats: true)
        return //comment out to perform timer experiment
    }

    // timer fires while we are in background, provided
    // (1) we scheduled it before going into the background
    // (2) we are running in the background (i.e. playing)
    func fired(_ timer:Timer) {
        print("bp timer fired")
        self.timer?.invalidate()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("bp in \(#function)")
        print("bp state while entering background: \(application.applicationState.rawValue)")
        return // comment out to experiment with background app performing immediate local notification

        //        delay(2) {
        //            print("bp trying to fire local notification")
        //            let ln = UILocalNotification()
        //            ln.alertBody = "Testing"
        //            application.presentLocalNotificationNow(ln)
        //        }
    }

    // we never receive this (if we are in background at the time)
    // but the notification does appear as banner/alert and in the notification center
    //    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    //        print("bp got local notification reading \(notification.alertBody)")
    //    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("bp in \(#function)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("bp or interrupter in \(#function)")
        //        let types : UIUserNotificationType = .alert
        //        let settings = UIUserNotificationSettings(types: types, categories: nil)
        //        application.registerUserNotificationSettings(settings)
        try? AVAudioSession.sharedInstance().setActive(true)
        // new iOS 8 feature
        let mute = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        let s = mute ? "to" : "not"
        print("I need \(s) mute my secondary audio at this point")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("bp or interrupter in \(#function)") //trying killing app from app switcher while playing in background, we receive this!
    }
    
}

