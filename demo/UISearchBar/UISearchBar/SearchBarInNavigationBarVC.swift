

import UIKit


class SearchBarInNavigationBarVC : AppTableVC, UISearchBarDelegate, UISearchControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let src = SearchResultsController(data: self.sectionData)
        let searcher = AppSearchController(searchResultsController: src)
        self.searcher = searcher
        searcher.searchResultsUpdater = src
        let b = searcher.searchBar
        b.sizeToFit()
        b.autocapitalizationType = .none
        
        /// put search bar into navigation bar
        self.navigationItem.titleView = b // *
        searcher.hidesNavigationBarDuringPresentation = false // *
        self.definesPresentationContext = true // *
        
        searcher.delegate = self
        searcher.modalPresentationStyle = .popover
        
        self.tableView.reloadData()
        tableView.contentOffset = CGPoint(0,b.frame.height)
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        /// 解决: 若用户没有点击 cancel ，SearchResultsController 不会 dismiss，引起视图图层混乱
        searcher.dismiss(animated: true, completion: nil)
    }

}
