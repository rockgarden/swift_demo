//
//  OnDemandResourcesVC.swift
//  BundleResource
//
//  iOS 9 App 瘦身
//  http://swift.gg/2016/01/07/app-thinning-appcoda/
//  http://blog.csdn.net/mengxiangyue/article/details/50753858

import UIKit

class OnDemandResourcesVC: UIViewController {

    /// NSBundleResourceRequest对象管理按需资源的可用性。按需资源是App Store上托管的应用内容，只有当您需要时才下载。您在开发期间通过创建名为标签的字符串标识符并为每个资源分配一个或多个标签来标识按需资源。 NSBundleResourceRequest对象管理由一个或多个标记标记的资源。您需要使用资源请求来通知系统何时需要托管代码以及何时完成访问。资源请求管理任何标记有托管标签的资源，这些资源尚未在设备上，并在资源准备就绪时通知您的应用程序。
    var tubbyRequest : NSBundleResourceRequest?
    @IBOutlet var iv : UIImageView!

    @IBAction func testForTubby() {
        let im = UIImage(named:"tubby")
        print("tubby is", im as Any)
        let c2 = NSDataAsset(name: "control2")
        print("control2 is", c2 as Any)
        print(Bundle.main.url(forResource: "control", withExtension: "mp3") as Any)
        print(tubbyRequest?.bundle.url(forResource: "control", withExtension: "mp3") as Any)
        print("frac is", self.tubbyRequest?.progress.fractionCompleted as Any)
    }

    @IBAction func startUsingTubby() {
        guard self.tubbyRequest == nil else {return}
        /// 只要至少有一个NSBundleResourceRequest对象正在管理标签，系统就不会尝试从设备上的存储中清除标记有标记的资源。在完成处理程序beginAccessingResources（completionHandler :)被成功调用后，应用程序可以访问资源。调用endAccessingResources（）后或资源请求对象被释放后，管理结束。
        self.tubbyRequest = NSBundleResourceRequest(tags: ["tubby"])
        self.tubbyRequest!.addObserver(self, forKeyPath: #keyPath(NSBundleResourceRequest.progress.fractionCompleted), options:[.new], context: nil)
        self.tubbyRequest!.beginAccessingResources { err in
            guard err == nil else {print(err as Any); return}
            DispatchQueue.main.async {
                let im = UIImage(named:"tubby")
                self.iv.image = im
            }
        }
    }

    @IBAction func stopUsingTubby() {
        guard self.tubbyRequest != nil else {return}
        self.iv.image = nil
        self.tubbyRequest!.endAccessingResources()
        self.tubbyRequest!.removeObserver(self, forKeyPath: #keyPath(NSBundleResourceRequest.progress.fractionCompleted))
        self.tubbyRequest = nil
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(change as Any)
    }

    deinit {
        stopUsingTubby()
    }
}


