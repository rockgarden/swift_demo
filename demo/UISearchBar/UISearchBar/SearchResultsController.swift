

import UIKit
import Swift

class SearchResultsController : UITableViewController {

    var originalData : [String]
    var filteredData = [String]()
    
    init(data:[[String]]) {
        /// don't use sections, so flatten the data into a single array of strings
        self.originalData = data.flatMap{$0}
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 
        cell.textLabel!.text = self.filteredData[indexPath.row]
        return cell
    }
}


// MARK: - UISearchResultsUpdating
/// 使用UISearchResultsUpdating协议根据用户在搜索栏中输入的信息来实时更新搜索结果。
extension SearchResultsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter {
            s in
            let found = s.range(of:target, options: .caseInsensitive)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
}



