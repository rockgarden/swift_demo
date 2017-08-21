//
//  AppDelegate.swift
//  EventKitDemo
//

import UIKit
import EventKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

let App_Delegate = UIApplication.shared.delegate as! AppDelegate
let database = EKEventStore()

func checkForEventAccess(_ type: EKEntityType, andThen f:(()->())? = nil) {
    let status = EKEventStore.authorizationStatus(for: type)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        database.requestAccess(to:.event) { ok, err in
            if ok {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        print("denied")
        break
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}



