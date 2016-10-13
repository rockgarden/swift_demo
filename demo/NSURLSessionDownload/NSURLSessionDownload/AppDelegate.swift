//
//  AppDelegate.swift
//  NSURLSessionDownload
//
//  Created by wangkan on 2016/10/12.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var image: UIImage!
    lazy var session: Foundation.URLSession = {
        let config = URLSessionConfiguration.background(
            withIdentifier: "com.neuburg.matt.ch37backgroundDownload")
        config.allowsCellularAccess = false
        // could set config.discretionary here
        let sess = Foundation.URLSession(
            configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return sess
    }()
    var ch: (() -> ())!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}

//MARK:- NSURLSessionDownloadDelegate
extension AppDelegate: URLSessionDownloadDelegate {
    func startDownload (_: AnyObject?) {
        let s = "http://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        let task = self.session.downloadTask(with: URL(string: s)!)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let prog = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        NSLog("%@", "downloaded \(100.0*prog)%")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "GotProgress"), object: self, userInfo: ["progress": prog])
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let d = try? Data(contentsOf: location) else { return }
        let im = UIImage(data: d)
        DispatchQueue.main.async {
            NSLog("%@", "finished; posting notification")
            self.image = im
            NotificationCenter.default.post(name: Notification.Name(rawValue: "GotPicture"), object: self)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        NSLog("%@", "completed; error: \(error)")
    }
    
    // === this is the Really Interesting Part
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        NSLog("%@", "hello hello, storing completion handler")
        self.ch = completionHandler
        let _ = self.session // make sure we have one
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        NSLog("%@", "calling completion handler")
        if self.ch != nil {
            self.ch()
        }
    }
}

