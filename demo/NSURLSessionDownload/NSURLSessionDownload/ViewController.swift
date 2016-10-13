//
//  ViewController.swift
//  NSURLSessionDownload
//
//  Created by wangkan on 2016/10/12.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var iv: UIImageView!

	lazy var configuration: URLSessionConfiguration = {
		let config = URLSessionConfiguration.ephemeral
		config.allowsCellularAccess = false
		config.urlCache = nil
		return config
	}()

	lazy var downloader: MyDownloader = {
		let d: MyDownloader = MyDownloader(configuration: self.configuration)
		return d
	}()

	@IBAction func doDownload (_ sender: AnyObject!) {
		self.iv.image = nil
		let s = "http://www.nasa.gov/sites/default/files/styles/1600x1200_autoletterbox/public/pia17474_1.jpg"
        // 使用"_"接收无用返回值
        _ = self.downloader.download(s) {
			url in
			if url == nil {
				return
			}
			if let d = try? Data(contentsOf: url) {
				let im = UIImage(data: d)
				DispatchQueue.main.async {
					self.iv.image = im
				}
			}
		}
	}

	deinit {
		self.downloader.cancelAllTasks()
		print("view controller dealloc")
	}

}

