

import UIKit

class SameVC : AppTableVC, UISearchBarDelegate {

    var originalSectionNames = [String]()
    var originalCellData = [[String]]()
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.originalCellData = self.sectionData
        self.originalSectionNames = self.sectionNames
        /// 使用相同的视图控制器显示可搜索的内容和搜索结果, 在同一张表中过滤数据 filter data in the very same table
        let searcher = AppSearchController(searchResultsController: nil)
        self.searcher = searcher

        if #available(iOS 9.1, *) {
            /// 一个布尔值，表示底层内容是否在搜索过程中被遮蔽，当此属性的值为true时，搜索控制器会在用户与搜索栏进行交互后，遮蔽包含可搜索内容的视图控制器。 当此属性为false时，搜索控制器不会遮挡原始视图控制器。 此属性仅控制原始视图控制器是否最初被遮蔽。 当用户在搜索栏中输入文本时，搜索控制器立即显示具有结果的搜索结果控制器。
            searcher.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searcher.searchResultsUpdater = self
        searcher.delegate = self

        let b = searcher.searchBar
        addSearchBar(b)
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.searching ? nil : self.sectionNames
    }
}


extension SameVC : UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        self.searching = true
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        self.searching = false
    }
}


extension SameVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let sb = searchController.searchBar
        let target = sb.text!
        if target == "" {
            self.sectionNames = self.originalSectionNames
            self.sectionData = self.originalCellData
            self.tableView.reloadData()
            return
        }
        // we have a target string
        self.sectionData = self.originalCellData.map {
            $0.filter {
                let found = $0.range(of:target, options: .caseInsensitive)
                return (found != nil)
            }
            }.filter {$0.count > 0}
        self.sectionNames = self.sectionData.map {String($0[0].characters.prefix(1))}
        self.tableView.reloadData()
    }
}

