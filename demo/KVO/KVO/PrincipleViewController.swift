//
//  PrincipleViewController.swift
//  TestKVOKVC
//
//  Created by yangjun zhu on 15/9/12.
//  Copyright © 2015年 Cactus. All rights reserved.
//

import UIKit

class PrincipleViewController: UIViewController {
	let people = People(name: "Owen", age: 1, sex: 1, address: Address())
	let namePeople = People(name: "Owen", age: 1, sex: 1, address: Address())
	let nameAgePeople = People(name: "Owen", age: 1, sex: 1, address: Address())

	deinit {
		self.namePeople.removeObserver(self, forKeyPath: "name")
		self.nameAgePeople.removeObserver(self, forKeyPath: "name")
		self.nameAgePeople.removeObserver(self, forKeyPath: "age")
	}

	fileprivate var myContext = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		self.namePeople.addObserver(self, forKeyPath: "name", options: NSKeyValueObservingOptions([.new, .old]), context: &myContext)
		self.nameAgePeople.addObserver(self, forKeyPath: "name", options: NSKeyValueObservingOptions([.new, .old]), context: &myContext)
		self.nameAgePeople.addObserver(self, forKeyPath: "age", options: NSKeyValueObservingOptions([.new, .old]), context: &myContext)

		self.printDescription("people", obj: people)
		self.printDescription("namePeople", obj: namePeople)
		self.printDescription("nameAgePeople", obj: nameAgePeople)

        print("-----------------start------------")
        print("Selector的方法：")
		print(self.people.method(for: #selector(setter: UIAccessibilityCustomAction.name)))
		print(self.namePeople.method(for: #selector(setter: UIAccessibilityCustomAction.name)))
		print(method_getImplementation(class_getInstanceMethod(object_getClass(self.people), #selector(setter: UIAccessibilityCustomAction.name))))
		print(method_getImplementation(class_getInstanceMethod(object_getClass(self.namePeople), #selector(setter: UIAccessibilityCustomAction.name))))
        print("-----------------end------------")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	fileprivate func classMethodNames(_ c: AnyObject) -> [String] {
		var arr = [String]()
		var methodCount: CUnsignedInt = 0;
		let methodList = class_copyMethodList(object_getClass(c), &methodCount);
		for i in 0...methodCount {
			arr.append(NSStringFromSelector(method_getName(methodList?[Int(i)])))
		}
		free(methodList);
		return arr;
	}

	fileprivate func printDescription(_ objectName: String, obj: AnyObject) {
		print("-----------------start------------")
		print("对象变量名字：", objectName)
		print("对象：", obj)
		print("类：", NSStringFromClass(obj.classForCoder))
		print("元类：", NSStringFromClass(object_getClass(obj)))
		print("实现的方法：", self.classMethodNames(obj).joined(separator: ", "))
		print("-----------------end------------")
	}

}
