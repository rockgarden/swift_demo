//
//  CandyTableViewController.swift
//  013-UISearchBar
//
//  Created by Audrey Li on 4/6/15.
//  Copyright (c) 2015 com.shomigo. All rights reserved.
//

import UIKit

private struct Constants {
    static let ShowDetailIdentifier = "showDetail"
}

class CandyTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var data = [Candy]()
    var filteredData = [Candy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension

        self.data = [Candy(category:"Chocolate", name:"chocolate Bar"),
            Candy(category:"Chocolate", name:"chocolate Chip"),
            Candy(category:"Chocolate", name:"dark chocolate"),
            Candy(category:"Hard", name:"lollipop"),
            Candy(category:"Hard", name:"candy cane"),
            Candy(category:"Hard", name:"jaw breaker"),
            Candy(category:"Other", name:"caramel"),
            Candy(category:"Other", name:"sour chew"),
            Candy(category:"Other", name:"gummi bear")]
        
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text changed \(searchText)")
        let len = data.count
        if len > 3 {
            data.removeSubrange(0..<4)
        } else {
            data.removeSubrange(0..<len)
        }
        //TODO: Demo Error "Array replace: subrange extends past the end"
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.ShowDetailIdentifier, sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.ShowDetailIdentifier {
            let  candyDetailViewController = segue.destination as UIViewController
            if sender as! UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow!
                candyDetailViewController.title = self.filteredData[(indexPath as NSIndexPath).row].name
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow!
                candyDetailViewController.title = self.data[(indexPath as NSIndexPath).row].name
            }
        }
    }
    
    func filterContentForSearchText(_ searchText:String){
        self.filteredData = self.data.filter({ (candy: Candy)-> Bool in
            let stringMatch = candy.name.range(of: searchText)
            return stringMatch != nil ? true : false
        })
    }
    
    func filterContentForSearchTextWithScope(_ searchText: String, scope: String = "All") {
        self.filteredData = self.data.filter({( candy : Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            let stringMatch = candy.name.range(of: searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
      //  self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        
        let scope = self.searchDisplayController!.searchBar.scopeButtonTitles! as [String]
        self.filterContentForSearchTextWithScope(self.searchDisplayController!.searchBar.text!, scope: scope[searchOption])
        return true
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
       // self.filterContentForSearchText(searchString)
        
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles! as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchTextWithScope(searchString!, scope: selectedScope)
        return true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredData.count
        } else {
            return data.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        var candy: Candy
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = filteredData[(indexPath as NSIndexPath).row]
        } else {
            candy = self.data[(indexPath as NSIndexPath).row]
        }
        
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
    }

}
