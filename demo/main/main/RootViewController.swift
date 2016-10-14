//
//  RootView.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-24.
//  Copyright (c) 2014年 zhaokaiyuan. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

	override func viewDidLoad() {

		super.viewDidLoad()

		self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")

		// tas.assaf()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return 2
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if (indexPath as NSIndexPath).row == 0 {
			self.navigationController?.pushViewController(MyTableViewController(), animated: true)
		} else if (indexPath as NSIndexPath).row == 1 {
			self.navigationController?.pushViewController(MyScrollViewController(), animated: true)
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cellID = "cell"
		var cell = tableView.dequeueReusableCell(withIdentifier: cellID)

		cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell") as UITableViewCell
		cell!.selectionStyle = UITableViewCellSelectionStyle.none
		var label = UILabel()
		label.frame = CGRect(x: 0, y: 0, width: 320, height: 36)
		label.font = UIFont.boldSystemFont(ofSize: 13)
		label.textColor = UIColor.black
		label.backgroundColor = UIColor.clear
		label.textAlignment = NSTextAlignment.center
		cell!.contentView.addSubview(label)
		label.tag = 1000001

		label = cell!.contentView.viewWithTag(1000001) as! UILabel

		if (indexPath as NSIndexPath).row == 0 {
			label.text = "tableView"
		} else if (indexPath as NSIndexPath).row == 1 {
			label.text = "scrollView"
		}
		return cell!
	}

}
