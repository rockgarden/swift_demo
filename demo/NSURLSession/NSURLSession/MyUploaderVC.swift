//
//  MyUploaderVC.swift
//  NSURLSession
//
//  Created by wangkan on 2016/11/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class MyUploaderVC: UIViewController {
    
    lazy var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        config.urlCache = nil
        return config
    }()
    
    lazy var uploader: MyUploader = {
        return MyUploader(configuration: self.configuration)
    }()
    
    @IBAction func doUpload (_ sender: AnyObject!) {
        let s = "http://127.0.0.1:8000/swift.png"
        let url = URL(string:s)!
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "swift", ofType: "png")
        let urlPath = URL(string: path!)
        let data = try! Data(contentsOf: urlPath!)
        
        self.uploader.upload(url: url, data: data, completionHandler: {_ in })
        self.uploader.upload(url: url, data: data) { url in
        }
        
        /// 使用"_"接收无用返回值
        //        _ = self.downloader.download(s) {
        //			url in
        //			if url == nil {
        //				return
        //			}
        //			if let d = try? Data(contentsOf: url) {
        //				let im = UIImage(data: d)
        //				DispatchQueue.main.async {
        //					self.iv.image = im
        //				}
        //			}
        //		}
    }
    
    deinit {
        self.uploader.cancelAllTasks()
        print("view controller dealloc")
    }
    
}
