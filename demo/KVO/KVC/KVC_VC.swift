//
//  KVC_VC.swift
//  KVO_KVC
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//
/// KVC，即是指 NSKeyValueCoding，一个非正式的Protocol，提供一种机制来间接访问对象的属性。而不是通过调用Setter、Getter方法访问。

import UIKit

class Dog: NSObject {
	var name: String = ""
}

class KVC_Class: NSObject {
	var theData = [
		[
			"description": "The one with glasses.",
			"name": "Manny"
		],
		[
			"description": "Looks a little like Governor Dewey.",
			"name": "Moe"
		],
		[
			"description": "The one without a mustache.",
			"name": "Jack"
		]
	]
    
	func countOfPepBoys() -> Int {
		return self.theData.count
	}
    
	func objectInPepBoysAtIndex(_ ix: Int) -> AnyObject {
		return self.theData[ix] as AnyObject
	}

}

class KVC_VC: UIViewController {

	var color: UIColor {
		get {
			print("someone called the color getter")
			return UIColor.red
		}
		set {
			print("someone called the color setter")
		}
	}

	// but there is, a simpler way: @objc(hue) == dynamic?
	@objc(hue) var color2: UIColor {
		get {
			print("someone called the color2 getter")
			return UIColor.red
		}
		set {
			print("someone called the color2 setter")
		}
	}

	var color3: UIColor?

	// these are compile errors, because they attempt to implement the accessors

	// func color3() -> UIColor? {
	// return self.color3
	// }
	//
	// func setColor3(c:UIColor?) {
	// self.color3 = c
	// }

	@objc(couleur) var color4: UIColor? {
		didSet {
			print("someone set couleur")
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		Thing().test()
		Thing().test2()
		Thing().test3()

		let obj = NSObject()
		// uncomment the next line to crash
		// obj.setValue("howdy", forKey:"keyName") // crash

		let d = Dog()
		d.setValue("Fido", forKey: "name") // no crash!
		print(d.name) // "Fido" - it worked!

        // NSObject.value
		let c = self.value(forKey: "hue") as? UIColor // "someone called the getter"
		print(c as Any) // Optional(UIDeviceRGBColorSpace 1 0 0 1)

		let myObject = KVC_Class()
		let arr = myObject.value(forKeyPath: "theData.name") as! [String]
		print(arr)
        /// 通过命名空间调用方法？
        let arr1: AnyObject = myObject.value(forKey: "pepBoys")! as AnyObject //调方法名包含pepBoys
        debugPrint(myObject.value(forKey: "countOfPepBoys") as Any)
        print(arr1)
        let arr2: AnyObject = myObject.value(forKeyPath: "pepBoys.name")! as AnyObject
        print(arr2)

		_ = obj

	}

}
