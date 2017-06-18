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
    var ubiq : URL!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.global(qos:.default).async {
            let fm = FileManager.default
            /*
             返回与提供的容器ID相对应的无处不在容器目录的根目录的文件URL。如果移动容器不存在或无法确定，则返回nil。
             返回与指定标识符相关联的iCloud容器的URL，并建立对该容器的访问。
             您可以使用此方法来确定应用程序的ubiquity container目录的位置，并配置应用程序的初始iCloud访问。您首次为某个ubiquity container调用此方法时，系统将您的应用程序的沙箱扩展为包含该容器。在iOS中，您必须至少调用此方法一次，然后再尝试在ubiquity container中搜索基于云的文件。如果您的应用程序访问多个ubiquity container，请为每个容器调用此方法一次。在macOS中，如果使用基于NSDocument的对象，则不需要调用此方法，因为系统会自动调用此方法。
             您可以使用此方法返回的URL来构建应用程序的无处不在容器中文件和目录的路径。将文档同步到云的每个应用程序必须至少有一个关联的ubiquity container来放置这些文件。此容器可以是应用程序的唯一，也可以由多个应用程序共享。
             重要:
             不要从应用程序的主线程调用此方法。因为这种方法可能需要花费大量的时间来设置iCloud并返回所请求的URL，所以您应该始终从次要线程调用它。要确定iCloud是否可用，特别是在启动时，请检查ubiquityIdentityToken属性的值。
             除了写入自己的ubiquity container之外，应用程序可以写入具有适当权限的任何容器目录。每个附加的ubiquity container应该作为com.apple.developer.ubiquity-container-identifiers权利数组中的附加值列出。
             要了解如何查看开发团队唯一的<TEAM_ID>值，请阅读“工具工作流程指南”中的“查看”小组ID。
             注意:
             每个容器ID字符串之前的开发组ID是与开发团队关联的唯一标识符。要了解如何查看开发团队唯一的<TEAM_ID>值，请阅读“工具工作流程指南”中的“查看”小组ID。
             */
            /// 需要在真机上测试
            let ubiq = fm.url(forUbiquityContainerIdentifier: "com.rockgarden.FileOperations")
            print("ubiq: \(String(describing: ubiq))")
            DispatchQueue.main.async {
                self.ubiq = ubiq
            }
        }
        return true
    }

    /*
     An incoherency is what should happen if the user switches on iCloud
     in midstream, while using the app or between uses of the app. We should detect this, and we should
     move the documents between worlds. When we detect that iCloud has been switched from off to on,
     we can call setUbiquitous:itemAtURL:destinationURL:error: to make this move.
     However, it is not so obvious what to do if iCloud is switched from on to off, as the document is now no longer available to us to rescue. 
     Again, see
     http://developer.apple.com/library/mac/#documentation/General/Conceptual/iCloudDesignGuide/Chapters/iCloudFundametals.html
     which discusses how to detect changes in status.
    */

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

        let vc = self.window!.rootViewController as! FileHandoffVC
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

