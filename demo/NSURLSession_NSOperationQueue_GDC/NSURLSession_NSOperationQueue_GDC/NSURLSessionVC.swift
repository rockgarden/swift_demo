//
//  NSURLSessionVC.swift
//  NSURLSession_NSOperationQueue_GDC
//
//  Created by wangkan on 16/8/16.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class NSURLSessionVC: UIViewController, NSURLSessionDownloadDelegate {

	var session = NSURLSession()

	@IBOutlet weak var imagen: UIImageView!
	@IBOutlet weak var progreso: UIProgressView!
	@IBAction func cargar(sender: UIButton) {
		let imageUrl: NSString = "http://c.hiphotos.baidu.com/image/pic/item/8cb1cb13495409235fa14adf9158d109b2de4942.jpg"
		let getImageTask: NSURLSessionDownloadTask = session.downloadTaskWithURL(NSURL(string: imageUrl as String)!)
		getImageTask.resume()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
		session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
		print("Download finished")
		let downloadedImage = UIImage(data: NSData(contentsOfURL: location)!)
		dispatch_async(dispatch_get_main_queue(), { () in
			self.imagen.image = downloadedImage
		})
	}

	func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		dispatch_async(dispatch_get_main_queue(), { () in
			let variable = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
			self.progreso.progress = variable
		})
    }
}

extension NSURLSessionVC {
    
    private func sampleNSURLSession() {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.allowsCellularAccess = false
        // only accept JSON answer
        sessionConfig.HTTPAdditionalHeaders = ["Accept": "application/json"]
        // timeouts and connections allowed
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.HTTPMaximumConnectionsPerHost = 2
        // create session, assign configuration
        let session = NSURLSession(configuration: sessionConfig)
        session.dataTaskWithURL(NSURL(string: "http://api.openweathermap.org")!, completionHandler: { (data, response, error) in
            let dic = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as? NSDictionary ?? [String: String]()
            if dic.count == 0 {
                return
            }
            
            debugPrint(dic)
            
            let city: NSString = (dic["name"] as! NSString)
            let kelvin: AnyObject! = (dic["main"] as! NSDictionary)["temp"]
            let kelvin_min: AnyObject! = (dic["main"] as! NSDictionary)["temp_min"]
            let kelvin_max: AnyObject! = (dic["main"] as! NSDictionary)["temp_max"]
            let celsius = kelvin as! Float - 274.15 as Float
            let celsius_min = kelvin_min as! Float - 274.15 as Float
            let celsius_max = kelvin_max as! Float - 274.15 as Float
            let humidity: AnyObject! = (dic ["main"] as! NSDictionary)["humidity"]
            let wind: AnyObject! = (dic ["wind"] as! NSDictionary)["speed"]
            
            // original thread
            dispatch_async(dispatch_get_main_queue(), { () in
                debugPrint(dic)
            })
        }).resume()
    }


}