

import UIKit

class A_SearchResultsC : UITableViewController {
    var originalData = [String]()
    var filteredData = [String]()
    weak var searchController : UISearchController?
    
    func takeData(_ data:[[String]]) {
        // we don't use sections, so flatten the data into a single array of strings
        self.originalData = data.joined().map{$0}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // we are now in total charge of the interface...
        // ... so make room for the tall search bar
        self.tableView.contentInset = UIEdgeInsetsMake(90, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = self.filteredData[(indexPath as NSIndexPath).row]
        return cell
    }
}

extension A_SearchResultsC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("update")
        self.searchController = searchController // keep a weak ref just in case
        let sb = searchController.searchBar
        let target = sb.text!
        self.filteredData = self.originalData.filter {
            s in
            var options = NSString.CompareOptions.caseInsensitive
            // we now have scope buttons; 0 means "starts with"
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                options.insert(.anchored)
            }
            let found = s.range(of: target, options: options)
            return (found != nil)
        }
        self.tableView.reloadData()
    }
}

extension A_SearchResultsC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("button")
        self.updateSearchResults(for: self.searchController!)
    }
}
