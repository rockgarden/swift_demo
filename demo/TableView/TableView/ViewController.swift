//
//  ViewController.swift
//  TableView
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// Number of rows
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	// DetailCells
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
		cell.textLabel!.text = "Cell text"
		cell.detailTextLabel?.text = "Cell Subtitle"
		cell.imageView!.image = UIImage(named: "image1.png")
		return cell
	}
	// Title
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Head"
	}
	// Foot Subtitle
	func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return "Foot"
	}

}

