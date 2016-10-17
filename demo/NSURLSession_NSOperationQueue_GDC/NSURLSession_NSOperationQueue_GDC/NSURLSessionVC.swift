//
//  NSURLSessionVC.swift
//  NSURLSession_NSOperationQueue_GDC
//
//  Created by wangkan on 16/8/16.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class NSURLSessionVC: UIViewController, URLSessionDownloadDelegate {

	var session = Foundation.URLSession()

	@IBOutlet weak var imagen: UIImageView!
	@IBOutlet weak var progreso: UIProgressView!
	@IBAction func cargar(_ sender: UIButton) {
		let imageUrl: NSString = "http://c.hiphotos.baidu.com/image/pic/item/8cb1cb13495409235fa14adf9158d109b2de4942.jpg"
		let getImageTask: URLSessionDownloadTask = session.downloadTask(with: URL(string: imageUrl as String)!)
		getImageTask.resume()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let sessionConfig = URLSessionConfiguration.default
		session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print("Download finished")
		let downloadedImage = UIImage(data: try! Data(contentsOf: location))
		DispatchQueue.main.async(execute: { () in
			self.imagen.image = downloadedImage
		})
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		DispatchQueue.main.async(execute: { () in
			let variable = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
			self.progreso.progress = variable
		})
    }
}

extension NSURLSessionVC {
    
    fileprivate func sampleNSURLSession() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = false
        // only accept JSON answer
        sessionConfig.httpAdditionalHeaders = ["Accept": "application/json"]
        // timeouts and connections allowed
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.httpMaximumConnectionsPerHost = 2
        // create session, assign configuration
        let session = Foundation.URLSession(configuration: sessionConfig)
        session.dataTask(with: URL(string: "http://api.openweathermap.org")!, completionHandler: { (data, response, error) in
            //let dic = [String: String]()
            guard let dic = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? NSDictionary else { return }
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
            DispatchQueue.main.async(execute: { () in
                debugPrint(dic)
            })
        }).resume()
    }


}
