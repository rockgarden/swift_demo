//
//  FirstViewController.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-23.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {
	var fakeData: NSMutableArray?

	func setupRefresh() {
		self.tableView.addHeaderWithCallback({
			self.fakeData!.removeAllObjects()
			for _ in 0..<15 {
				let text: String = "内容" + String(arc4random_uniform(10000))
				self.fakeData!.add(text)
			}

			let delayInSeconds: Int64 = 1000000000 * 2

			let popTime: DispatchTime = DispatchTime.now() + Double(delayInSeconds) / Double(NSEC_PER_SEC)
			DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
				self.tableView.reloadData()
				self.tableView.headerEndRefreshing()
			})

		})

		self.tableView.addFooterWithCallback({
			for _ in 0 ..< 10 {
				let text: String = "内容" + String(arc4random_uniform(10000))
				self.fakeData!.add(text)
			}
			let delayInSeconds: Int64 = 1000000000 * 2
			let popTime: DispatchTime = DispatchTime.now() + Double(delayInSeconds) / Double(NSEC_PER_SEC)
			DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
				self.tableView.reloadData()
				self.tableView.footerEndRefreshing()
				 self.tableView.setFooterHidden(true)
			})
		})
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		fakeData = NSMutableArray()
		for _ in 0 ..< 15 {
			let text: String = "内容" + String(arc4random_uniform(10000))
			self.fakeData!.add(text)
		}
		self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
		self.setupRefresh()
		// tas.assaf()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.fakeData!.count
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cellID = "cell"
		var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
		cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell") as UITableViewCell
		cell!.selectionStyle = UITableViewCellSelectionStyle.none
		let statusLabel = UILabel()
		statusLabel.frame = CGRect(x: 0, y: 0, width: 320, height: 36)
		statusLabel.font = UIFont.boldSystemFont(ofSize: 13)
		statusLabel.textColor = UIColor.black
		statusLabel.backgroundColor = UIColor.clear
		statusLabel.textAlignment = NSTextAlignment.center
		cell!.contentView.addSubview(statusLabel)
		statusLabel.tag = 1000001
		statusLabel.text = fakeData!.object(at: (indexPath as NSIndexPath).row) as? String

		return cell!
	}

}

