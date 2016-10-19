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
	var titleButton = UIButton(type: UIButtonType.system)
	var totalLabel = UILabel(frame: (CGRect(x: 70, y: 26, width: 60, height: 15)))
	var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 26))
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

	func configureTitleButton(_ buttonTitle: String!, haveSubTitle: Bool) {
		titleButton.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
		self.navigationItem.titleView = titleButton
		if haveSubTitle {
			titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 27)
			titleLabel.font = UIFont(name: "STHeitiSC-Light", size: 19)
			titleLabel.textAlignment = .center
			totalLabel.sizeToFit()
			let w = totalLabel.frame.width
			let x = (200 - w) / 2
			totalLabel.frame = CGRect(x: x, y: 26, width: w + 2, height: 15)
			totalLabel.backgroundColor = UIColor.black.withAlphaComponent(0.1)
			totalLabel.clipsToBounds = true
			totalLabel.textAlignment = .center
			totalLabel.font = UIFont(name: "STHeitiSC-Light", size: 13)
			totalLabel.layer.cornerRadius = 4
			titleButton.addSubview(totalLabel)
		}
		titleLabel.text = buttonTitle
		titleButton.addSubview(titleLabel)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dvc = segue.destination as? GreetingDetailViewController {
			dvc.data = dvcData
		}
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		totalLabel.text = "1000000000"
		configureTitleButton("业务开通", haveSubTitle: true)
		self.navigationItem.rightBarButtonItem = searchButton
	}

	func showSearch() {
		self.navigationItem.rightBarButtonItem = nil
		self.navigationItem.titleView = resultSearchController.searchBar
		resultSearchController.searchBar.becomeFirstResponder()
	}

	func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text
		if searchText == nil || searchText == "" {
			filteredItems = items
		} else {
			var tempArray = items[Constant.GreetingOBJHandlerSectionKey]
			// Be careful when to cast the data. Here it must be at the right side, or it will not work.
			tempArray = (tempArray as! [Greeting]).filter { $0.language.lowercased().range(of: searchController.searchBar.text!) != nil || $0.greetingText.lowercased().range(of: searchController.searchBar.text!) != nil }
			filteredItems[Constant.GreetingOBJHandlerSectionKey] = tempArray
		}
		dataSource.updateItems(filteredItems)
		self.collectionView.reloadData()
	}

	func addSearchBar() {
		searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(GreetingNewViewController.showSearch))
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
        configureSearchBar(self.resultSearchController.searchBar)
	}

    // 定义searchBar样式
    func configureSearchBar(_ searchBar: UISearchBar) {
        searchBar.placeholder = "请输入客户名称或简拼"
        debugPrint("searchBar.text", searchBar.text) //searchBar.text不会为nil
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.white
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.enablesReturnKeyAutomatically = false //设置ReturnKey是无text输入时也直接可用
    }

}

struct Constant {
	static let GreetingNewViewControllerCell = "coCell"
	static let GreetingNewViewControllerSegue = "showGreetingDetail"
	static let GreetingJSONFileName = "greetings"
	static let GreetingOBJHandlerSectionKey = "section0"
}
