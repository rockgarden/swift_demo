//
//  MyDownloaderVC.swift
//  NSURLSessionDownload
//
//  Created by wangkan on 2016/10/12.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class MyDownloaderVC: UIViewController {

	@IBOutlet var iv: UIImageView!

	lazy var configuration: URLSessionConfiguration = {
        /// .ephemeral 返回对缓存，Cookie或凭据不使用持久存储的会话配置。短暂会话配置对象类似于默认会话配置对象，但相应的会话对象不将缓存，凭据存储或任何与会话相关的数据存储到磁盘。相反，会话相关数据存储在RAM中。短暂会话将数据写入磁盘的唯一时间是当您将URL写入文件的内容时。
		let config = URLSessionConfiguration.ephemeral
		config.allowsCellularAccess = false
		config.urlCache = nil
		return config
	}()

	lazy var downloader: MyDownloader = {
		return MyDownloader(configuration: self.configuration)
	}()

	@IBAction func doDownload (_ sender: AnyObject!) {
		self.iv.image = nil
		let s = "http://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"

        let url = URL(string:s)!
        self.downloader.download(url: url) { url in
            if let url = url, let d = try? Data(contentsOf: url) {
                let im = UIImage(data:d)
                self.iv.image = im
            }
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
		self.downloader.cancelAllTasks()
		print("view controller dealloc")
	}

}

