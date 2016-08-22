//
//  ViewController.swift
//  KVO
//
//  Created by wangkan on 16/8/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var objectA: NSObject!
	var objectB: NSObject!
    
    var objectC: NSObject!
    var objectD: NSObject!

	override func viewDidLoad() {
		super.viewDidLoad()
        
		objectA = MyClass1()
		objectB = MyClass2()
		let opts: NSKeyValueObservingOptions = [.New, .Old]
		objectA.addObserver(objectB, forKeyPath: "value", options: opts, context: &con)
		(objectA as! MyClass1).value = true
		// comment out next line if you wish to crash
		objectA.removeObserver(objectB, forKeyPath: "value")
		objectA = nil
        
        objectC = MyObjectToObserve()
        objectD = MyObserver()
        (objectC as! MyObjectToObserve).updateDate()
        (objectC as! MyObjectToObserve).updateDate()
        (objectC as! MyObjectToObserve).updateDate()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}

