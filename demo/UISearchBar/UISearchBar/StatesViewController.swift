import UIKit

class Pop_SRC_VC: AppTableVC, UISearchBarDelegate {

	override func viewDidLoad() {
        super.viewDidLoad()
        setupPop_SRC()
    }

    //FIXME: Just run on iPad
    fileprivate func setupPop_SRC() {
        let src = Pop_SRC(data: self.sectionData)
		
		let searcher = AppSearchController(searchResultsController: src)
		self.searcher = searcher

        /// difficulty detecting dismissal of the popover
        searcher.delegate = self
        if let pres = searcher.presentationController {
            print("setting presentation controller delegate")
            pres.delegate = self
        }
        //(searcher.presentationController as! UIPopoverPresentationController).delegate = self

		// no effect in this situation:
		//searcher.hidesNavigationBarDuringPresentation = true
		// searcher.dimsBackgroundDuringPresentation = false
		// FIXME: make it a popover! 设置definesPresentationContext为true，我们保证在UISearchController在激活状态下用户push到下一个view controller之后search bar仍留在界面上。
//		self.definesPresentationContext = true
//		searcher.modalPresentationStyle = .popover
//		searcher.preferredContentSize = CGSize(width: 400, height: 400)
		// specify who the search controller should notify when the search bar changes
		// searchResultUpdater是UISearchController的一个属性，它的值必须实现UISearchResultsUpdating协议，这个协议让我们的类在UISearchBar文字改变时被通知到

		searcher.searchResultsUpdater = src
        
		// 将搜索控制器的搜索栏放入界面
		let b = searcher.searchBar

		b.sizeToFit()
        //b.frame.size.width = 250

        // crucial, trust me on this one
        b.scopeButtonTitles = ["Starts", "Contains"]

        // WARNING: do NOT call showsScopeBar! it messes things up!
        // (buttons will show during search if there are titles)

		b.autocapitalizationType = .none

        // FIXME: 在 navigationVC 中 高度异常
        self.tableView.tableHeaderView = b
        self.tableView.reloadData()
        self.tableView.scrollToRow(at:
            IndexPath(row: 0, section: 0),
                                   at:.top, animated:false)

        // FIXME: 放入NavBar dismiss 异常
		//self.navigationItem.titleView = b
		//b.showsCancelButton = true //no effect

        /// 可以进一步配置UISearchController, 或者可以配置其presentationController（一个UIPopoverPresentationController）
	}

}

extension Pop_SRC_VC: UISearchControllerDelegate {
	func presentSearchController(_ searchController: UISearchController) { print(#function) }
	func willPresentSearchController(_ searchController: UISearchController) { print(#function) }
	func didPresentSearchController(_ searchController: UISearchController) { print(#function) }
	// these next functions are not called, I regard this as a bug
	func willDismissSearchController(_ searchController: UISearchController) { print(#function) }
	func didDismissSearchController(_ searchController: UISearchController) { print(#function) }
}

extension Pop_SRC_VC: UIPopoverPresentationControllerDelegate {
	func prepareForPopoverPresentation(_ pop: UIPopoverPresentationController) {
		print("prepare")
		// print(pop.sourceView)
		// print(pop.passthroughViews)
		// print(pop.delegate)
	}

	func popoverPresentationControllerShouldDismissPopover(_ pop: UIPopoverPresentationController) -> Bool {
		print("pop should dismiss")
		self.searcher.searchBar.text = nil // woo-hoo! fix dismissal failure to empty
		return true
	}
    
	func popoverPresentationControllerDidDismissPopover(_ pop: UIPopoverPresentationController) {
		print("pop dismiss")
		self.searcher.presentationController?.delegate = self // this is the big bug fix
	}
}

// not called, seems like a bug to me
extension Pop_SRC_VC: UIAdaptivePresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return .none
	}
}

