//
//  ViewController.swift
//  NSURLSession_NSOperationQueue_GDC
//
//  Created by wangkan on 16/8/13.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ViewController {

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

    /**
     顺序列队
     */
	private func sampleNSOperationQueue() {
		let queue = NSOperationQueue()
		let operation1: NSBlockOperation = NSBlockOperation (
			block: {
				self.getWebs() //run first
				let operation2: NSBlockOperation = NSBlockOperation(block: {
					self.loadWebs() //run second
				})
				queue.addOperation(operation2)
		})
		queue.addOperation(operation1)
		super.viewDidLoad()
	}

	func loadWebs() {
		let urls = NSMutableArray (
			NSURL(string: "http://www.google.es")!,
			NSURL(string: "http://www.apple.com")!,
			NSURL(string: "http://carlosbutron.es")!,
			NSURL(string: "http://www.bing.com")!,
			NSURL(string: "http://www.yahoo.com")!)
		urls.addObjectsFromArray(googlewebs as [AnyObject])
		for iterator: AnyObject in urls {
			/// NSData(contentsOfURL:iterator as! NSURL)
			debugPrint("Downloaded \(iterator)")
		}
	}

	var googlewebs: NSArray = []

	func getWebs() {
		let languages: NSArray = ["com", "ad", "ae", "com.af", "com.ag", "com.ai", "am", "co.ao", "com.ar", "as", "at"]
		let languageWebs = NSMutableArray()
		for (var i = 0;i < languages.count; i++) {
			let webString: NSString = "http://www.google.\(languages[i])"
			languageWebs.addObject(NSURL(fileURLWithPath: webString as String))
		}
		googlewebs = languageWebs
	}
}

