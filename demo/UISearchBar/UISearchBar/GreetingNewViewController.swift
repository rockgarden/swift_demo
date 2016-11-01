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
	var items: [String: [AnyObject]]!
	var filteredItems: [String: [AnyObject]]!
	var dataSource: MultiSectionCollectionViewDataSource!

	var dvcData: AnyObject! // data for destinationViewController

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "CollectionView Search Demo"
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

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let dvc = segue.destination as? GreetingDetailViewController {
			dvc.data = dvcData
		}
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
        searchBar.placeholder = "请输入名称"
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
