//
//  AppDelegate.swift
//  CoreData
//
//  Created by wangkan on 2016/11/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import CoreData

let App_Delegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var context: NSManagedObjectContext!
    /// Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataExample")
        container.loadPersistentStores { desc, err in
            print(desc)
            if let err = err {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(err), \((err as NSError).userInfo)")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        context = persistentContainer.viewContext

        try? writeData()

        /* only for test. Use topViewController send context */
        //let nav = self.window!.rootViewController as! UINavigationController
        //let tvc = nav.topViewController as! GroupLister
        //tvc.managedObjectContext = self.context
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        try! self.saveContext()
    }

    func writeData() throws {
        let context = persistentContainer.viewContext
        let group = Group(context: context)
        group.name = "init"
        group.uuid = NSUUID().uuidString
        group.timestamp = NSDate()
        do {
            try self.context.save()
        } catch {
            //catch the errors here
        }
        let person = Person(context: context)
        person.group = group
        person.firstName = "Foo"
        person.lastName = "Bar"
        person.cars = NSSet(array: [
            Car(context: context).configured(maker: "VW",
                                             model: "Sharan",
                                             owner: person),
            Car(context: context).configured(maker: "VW",
                                             model: "Tiguan",
                                             owner: person)
            ])
        try saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }

}

extension Car {
    func configured(maker _maker: String, model _model: String, owner _owner: Person) -> Self {
        maker = _maker
        model = _model
        owner = _owner
        return self
    }
}

enum ReadDataExceptions : Error{
    case MoreThanOnePersonCameBack
}
