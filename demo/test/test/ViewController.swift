//
//  ViewController.swift
//  test
//
//  Created by wangkan on 16/8/11.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
		sessionConfig.allowsCellularAccess = false
		// only accept JSON answer
		sessionConfig.HTTPAdditionalHeaders = ["Accept": "application/json"]
		// timeouts and connections allowed
		sessionConfig.timeoutIntervalForRequest = 30.0
		sessionConfig.timeoutIntervalForResource = 60.0
		sessionConfig.HTTPMaximumConnectionsPerHost = 1
		// create session, assign configuration
		let session = NSURLSession(configuration: sessionConfig)
		session.dataTaskWithURL(NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Barcelona,es&appid=2de143494c0b295cca9337e1e96b00e0")!, completionHandler: { (data, response, error) in
			let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))) as? NSDictionary ?? [String: String]()

			if dic.count == 0 {
				return
			}

			print(dic)

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

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    func testFetchingProfile_ReturnsPopulatedUser() {
        // Arrage
        let responseString = "{\"login\": \"dasdom\", \"id\": 1234567}"
        let responseData = responseString.dataUsingEncoding(NSUTF8StringEncoding)!
        let sessionMock = URLSessionMock(data: responseData, response: nil, error: nil)
        let apiClient = APIClient()
        apiClient.session = sessionMock

        // Act
        apiClient.fetchProfileWithName("dasdom")

        // Assert
        let user = apiClient.user
        let expectedUser = User(name: "dasdom", id: 1234567)
        XCTAssertEqual(user, expectedUser)
    }

}

