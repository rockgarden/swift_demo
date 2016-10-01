//
//  GreetingNewViewController.swift
//  013-UISearchBar
//
//  Created by Audrey Li on 4/7/15.
//  Copyright (c) 2015 com.shomigo. All rights reserved.
//

import UIKit

class GreetingNewViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var searchbarView: UIView!

	var resultSearchController = UISearchController()
	var searchButton: UIBarButtonItem!
	var titleButton = UIButton(type: UIButtonType.System)
	var totalLabel = UILabel(frame: (CGRectMake(70, 26, 60, 15)))
	var titleLabel = UILabel(frame: CGRectMake(0, 0, 200, 26))
	var items: [String: [AnyObject]]!
	var filteredItems: [String: [AnyObject]]!
	var dataSource: MultiSectionCollectionViewDataSource!

	var dvcData: AnyObject! // data for destinationViewController

	override func viewDidLoad() {
		super.viewDidLoad()
		configureTitleButton("用户投诉", haveSubTitle: true)
		self.items = GreetingObjectHandler(filename: Constant.GreetingJSONFileName).getGreetingsAsAnyObjects()
		filteredItems = items

		let md = MD()
		self.dataSource = MultiSectionCollectionViewDataSource(items: filteredItems, cellIdentifier: Constant.GreetingNewViewControllerCell, viewController: self, segueIdentifier: Constant.GreetingNewViewControllerSegue, configureBlock: { (cell, item) -> () in
			let actualCell = cell as! CollectionViewCell
			actualCell.configureForItem(item)
			actualCell.backgroundColor = md.randomDark()
		})
		self.collectionView.reloadData()
		collectionView.dataSource = dataSource
		collectionView.delegate = dataSource
		addSearchBar()
	}

	func configureTitleButton(buttonTitle: String!, haveSubTitle: Bool) {
		titleButton.frame = CGRectMake(0, 0, 200, 44)
		self.navigationItem.titleView = titleButton
		if haveSubTitle {
			titleLabel.frame = CGRectMake(0, 0, 200, 27)
			titleLabel.font = UIFont(name: "STHeitiSC-Light", size: 19)
			titleLabel.textAlignment = .Center
			totalLabel.sizeToFit()
			let w = totalLabel.frame.width
			let x = (200 - w) / 2
			totalLabel.frame = CGRectMake(x, 26, w + 2, 15)
			totalLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
			totalLabel.clipsToBounds = true
			totalLabel.textAlignment = .Center
			totalLabel.font = UIFont(name: "STHeitiSC-Light", size: 13)
			totalLabel.layer.cornerRadius = 4
			titleButton.addSubview(totalLabel)
		}
		titleLabel.text = buttonTitle
		titleButton.addSubview(titleLabel)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let dvc = segue.destinationViewController as? GreetingDetailViewController {
			dvc.data = dvcData
		}
	}

	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		totalLabel.text = "1000000000"
		configureTitleButton("业务开通", haveSubTitle: true)
		self.navigationItem.rightBarButtonItem = searchButton
	}

	func showSearch() {
		self.navigationItem.rightBarButtonItem = nil
		self.navigationItem.titleView = resultSearchController.searchBar
		resultSearchController.searchBar.becomeFirstResponder()
	}

	func updateSearchResultsForSearchController(searchController: UISearchController) {
		let searchText = searchController.searchBar.text
		if searchText == nil || searchText == "" {
			filteredItems = items
		} else {
			var tempArray = items[Constant.GreetingOBJHandlerSectionKey]
			// Be careful when to cast the data. Here it must be at the right side, or it will not work.
			tempArray = (tempArray as! [Greeting]).filter { $0.language.lowercaseString.rangeOfString(searchController.searchBar.text!) != nil || $0.greetingText.lowercaseString.rangeOfString(searchController.searchBar.text!) != nil }
			filteredItems[Constant.GreetingOBJHandlerSectionKey] = tempArray
		}
		dataSource.updateItems(filteredItems)
		self.collectionView.reloadData()
	}

	func addSearchBar() {
		searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(GreetingNewViewController.showSearch))
		navigationItem.rightBarButtonItem = searchButton
		self.resultSearchController = {
			let controller = UISearchController(searchResultsController: nil)
			controller.searchResultsUpdater = self
			controller.dimsBackgroundDuringPresentation = false
			controller.hidesNavigationBarDuringPresentation = false // default true
			controller.searchBar.sizeToFit()
			return controller
		}()
		self.resultSearchController.searchBar.delegate = self
	}

}

struct Constant {
	static let GreetingNewViewControllerCell = "coCell"
	static let GreetingNewViewControllerSegue = "showGreetingDetail"
	static let GreetingJSONFileName = "greetings"
	static let GreetingOBJHandlerSectionKey = "section0"
}