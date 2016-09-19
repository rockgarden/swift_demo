//
//  ViewController.swift
//  RefreshControl
//
//  Created by wangkan on 16/9/18.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	let cellIdentifer = "NewCellIdentifier"

	let favoriteEmoji = ["🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆","🏃🏃🏃🏃🏃", "💩💩💩💩💩", "👸👸👸👸👸", "🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆"]
	let newFavoriteEmoji = ["🏃🏃🏃🏃🏃", "💩💩💩💩💩", "👸👸👸👸👸", "🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆"]
	var emojiData = [String]()
    var emojiTableView: UITableView!
    var tableViewController = UITableViewController(style: .Grouped)
	var refreshControl = UIRefreshControl()
	// var navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 375, height: 64))

    override func awakeFromNib() {
        super.awakeFromNib()
        emojiTableView = tableViewController.tableView
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "emoji"
		// self.navBar.barStyle = UIBarStyle.BlackTranslucent
		// self.view.addSubview(navBar)

		emojiData = favoriteEmoji

		emojiTableView.backgroundColor = UIColor(red: 0.092, green: 0.096, blue: 0.116, alpha: 1)
		emojiTableView.dataSource = self
		emojiTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
		emojiTableView.rowHeight = UITableViewAutomaticDimension
		emojiTableView.estimatedRowHeight = 60.0
		emojiTableView.tableFooterView = UIView(frame: CGRectZero)
		emojiTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		emojiTableView.translatesAutoresizingMaskIntoConstraints = false

		tableViewController.refreshControl = self.refreshControl
		self.refreshControl.addTarget(self, action: #selector(ViewController.didRoadEmoji), forControlEvents: .ValueChanged)
		self.refreshControl.backgroundColor = UIColor(red: 0.113, green: 0.113, blue: 0.145, alpha: 1)
		let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())", attributes: attributes)
		self.refreshControl.tintColor = UIColor.whiteColor()

		self.view.addSubview(emojiTableView)

		NSLayoutConstraint.activateConstraints([
			emojiTableView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor),
			emojiTableView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor),
			emojiTableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
			emojiTableView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.bottomAnchor)
		])

	}

	// UITableViewDataSource

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return emojiData.count
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer)! as UITableViewCell
		cell.textLabel!.text = self.emojiData[indexPath.row]
		cell.textLabel!.textAlignment = NSTextAlignment.Center
		cell.textLabel!.font = UIFont.systemFontOfSize(50)
		cell.backgroundColor = UIColor.clearColor()
		cell.selectionStyle = UITableViewCellSelectionStyle.None

		return cell
	}

	// RoadEmoji

	func didRoadEmoji() {
		self.emojiData = newFavoriteEmoji
		animateTable(emojiTableView)
		self.refreshControl.endRefreshing()
	}

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

    func animateTable(table: UITableView) {
        table.reloadData()
        let cells = table.visibleCells
        let tableHeight: CGFloat = table.bounds.size.height
        for i in cells {
            let cell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        var index = 0
        for a in cells {
            let cell = a as UITableViewCell
            UIView.animateWithDuration(1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

}

