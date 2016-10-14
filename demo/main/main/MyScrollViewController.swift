//
//  SecondViewController.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-23.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//

import UIKit

class MyScrollViewController: UIViewController {
	var scrollView: UIScrollView?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white
		scrollView = UIScrollView(frame: self.view.frame)
		self.view.addSubview(scrollView!)
		scrollView!.contentSize = self.view.frame.size
		scrollView!.backgroundColor = UIColor.clear
		self.setupRefresh()
	}

	func setupRefresh() {
		self.scrollView!.addHeaderWithCallback({
			let delayInSeconds: Int64 = 1000000000 * 2
			let popTime: DispatchTime = DispatchTime.now() + Double(delayInSeconds) / Double(NSEC_PER_SEC)
			DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
				self.scrollView!.contentSize = self.view.frame.size
				self.scrollView!.headerEndRefreshing()
			})
		})

		self.scrollView!.addFooterWithCallback({
			let delayInSeconds: Int64 = 1000000000 * 2
			let popTime: DispatchTime = DispatchTime.now() + Double(delayInSeconds) / Double(NSEC_PER_SEC)
			DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
				var size: CGSize = self.scrollView!.frame.size
				size.height = size.height + 300
				self.scrollView!.contentSize = size
				self.scrollView!.footerEndRefreshing()
			})
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

