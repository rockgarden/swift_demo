//
//  BackgroundDownloadVC.swift
//  NSURLSessionDownload
//
//  Created by wangkan on 2016/10/12.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

extension Notification.Name {
    /// NSNotification.Name(rawValue: "GotPicture") -> .gotProgress
    static let gotProgress = Notification.Name("gotProgress")
    static let gotPicture = Notification.Name("gotPicture")
}

class BackgroundDownloadVC: UIViewController {
    
    @IBOutlet var iv: UIImageView!
    @IBOutlet var prog: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(gotPicture), name: .gotPicture, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotProgress), name: .gotProgress, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.grabPicture()
    }
    
    @IBAction func doStart (_ sender: AnyObject!) {
        self.prog.progress = 0
        self.iv.image = nil
        APP.startDownload(self)
    }
    
    func grabPicture () {
        NSLog("%@", "grabbing picture")
        self.iv.image = APP.image
        APP.image = nil
        if self.iv.image != nil {
            self.prog.progress = 1
        }
    }
    
    func gotPicture (_ n: Notification) {
        self.grabPicture()
    }
    
    func gotProgress (_ n: Notification) {
        if let ui = (n as NSNotification).userInfo {
            if let prog = ui["progress"] as? NSNumber {
                self.prog.progress = Float(prog.doubleValue)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func crash (_ sender: Any?) {
        fatalError("kaboom")
    }
    
}

