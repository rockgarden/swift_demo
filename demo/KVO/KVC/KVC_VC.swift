//
//  KVC_VC.swift
//  KVO_KVC
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

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

	// but there is, in Swift 2.0, a simpler way:
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

		let c = self.value(forKey: "hue") as? UIColor // "someone called the getter"
		print(c) // Optional(UIDeviceRGBColorSpace 1 0 0 1)

		let myObject = MyClass()
		let arr = myObject.value(forKeyPath: "theData.name") as! [String]
		print(arr)
		do {
			let arr: AnyObject = myObject.value(forKey: "pepBoys")! as AnyObject
			print(arr)
			let arr2: AnyObject = myObject.value(forKeyPath: "pepBoys.name")! as AnyObject
			print(arr2)
		}

		_ = obj

	}

}
