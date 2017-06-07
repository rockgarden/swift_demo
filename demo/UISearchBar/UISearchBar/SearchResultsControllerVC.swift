

import UIKit

class SearchResultsControllerVC : AppTableVC, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 实例化将显示搜索结果的视图控制器
        let src = SearchResultsController(data: sectionData)
        // 实例化一个搜索控制器并保持活动 instantiate a search controller and keep it alive
        let searcher = AppSearchController(searchResultsController: src)
        self.searcher = searcher
        // specify who the search controller should notify when the search bar changes
        searcher.searchResultsUpdater = src

        let b = searcher.searchBar
        addSearchBar(b)
        // crucial, trust me on this one
        // b.scopeButtonTitles = ["Hey", "Ho"] // shows during search only; uncomment to see
        // (not used in this example; just showing the interface)
        // WARNING: do NOT call showsScopeBar! it messes things up!
        // (buttons will show during search if there are titles)
    }
    
}
