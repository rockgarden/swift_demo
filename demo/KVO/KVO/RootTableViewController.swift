//
//  RootTableViewController.swift
//  TestKVOKVC
//
//  Created by yangjun zhu on 15/9/12.
//  Copyright © 2015年 Cactus. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {

    var objectA: NSObject!
    var objectB: NSObject!
    var objectC: NSObject!
    var objectD: NSObject!
    var objectE: NSObject!
    var objectF: NSObject!

	override func viewDidLoad() {
		super.viewDidLoad()
        testKVO()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

    func testKVO() {
        objectA = ObjectToObserve()
        objectB = Observer()
        let opts: NSKeyValueObservingOptions = [.New, .Old]
        objectA.addObserver(objectB, forKeyPath: "value", options: opts, context: &con)
        (objectA as! ObjectToObserve).value = true
        // must removeObserver otherwise comment out next line if you wish to crash
        objectA.removeObserver(objectB, forKeyPath: "value")
        objectA = nil

        objectC = ObjectToObserve1()
        objectD = Observer1()
        (objectC as! ObjectToObserve1).updateDate()

        objectE = ArrayToObserve()
        objectF = ArrayObserver()
//        (objectE as! ArrayToObserve).changeArray()
    }
}
