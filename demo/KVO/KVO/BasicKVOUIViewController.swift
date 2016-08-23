//
//  BasicKVOUIViewController.swift
//  TestKVOKVC
//
//  Created by yangjun zhu on 15/9/13.
//  Copyright © 2015年 Cactus. All rights reserved.
//

import UIKit

class BasicKVOUIViewController: UIViewController {
	var obj: testClass!

	deinit {

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.obj = testClass()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}

class MyClass: NSObject {
	dynamic var a = "a0"
	dynamic var b = "b0"
	dynamic var c = "c0"
	dynamic var d = "d0"
	dynamic var e = "e0"
	dynamic var f = "f0"
}

class MyClass1: NSObject {
	var x = "x0"
}

class MyChildClass: MyClass1 {
	dynamic override var x: String {
		get { return super.x }
		set { super.x = newValue }
	}
}

private var myContext = 0

class testClass: NSObject {

	var myObject: MyClass!

	deinit {
		self.myObject.removeObserver(self, forKeyPath: "a")
		self.myObject.removeObserver(self, forKeyPath: "b")
		self.myObject.removeObserver(self, forKeyPath: "c")
		self.myObject.removeObserver(self, forKeyPath: "d")
		self.myObject.removeObserver(self, forKeyPath: "e")
		self.myObject.removeObserver(self, forKeyPath: "f")
	}

	override init() {
		super.init()
		self.myObject = MyClass()

		print("------------------设置监听------------------")
		self.myObject.addObserver(self,
			forKeyPath: "a",
			options: .Initial,
			context: &myContext)
		self.myObject.addObserver(self,
			forKeyPath: "b",
			options: NSKeyValueObservingOptions([.New]),
			context: &myContext)
		self.myObject.addObserver(self,
			forKeyPath: "c",
			options: NSKeyValueObservingOptions([.Old]),
			context: &myContext)
		self.myObject.addObserver(self,
			forKeyPath: "d",
			options: NSKeyValueObservingOptions([.New, .Old]),
			context: &myContext)
		self.myObject.addObserver(self,
			forKeyPath: "e",
			options: NSKeyValueObservingOptions([.Prior]),
			context: &myContext)
		self.myObject.addObserver(self,
			forKeyPath: "f",
			options: NSKeyValueObservingOptions([.Initial, .New, .Old, .Prior]),
			context: &myContext)
		print("------------------属性设置------------------")
		self.myObject.a = "a1"
		self.myObject.b = "b1"
		self.myObject.c = "c1"
		self.myObject.d = "d1"
		self.myObject.e = "e1"
		self.myObject.f = "f1"
	}

	override func observeValueForKeyPath(keyPath: String?,
		ofObject object: AnyObject?,
		change: [String: AnyObject]?,
		context: UnsafeMutablePointer<Void>){
		if let change = change where context == &myContext {
			print("**************************")
			print(keyPath, "改变了")
			print(object)
			print(change)
			print(context)
			print("**************************")
			return
		}
        // 不会执行, 执行 就 crash
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
	}
}

