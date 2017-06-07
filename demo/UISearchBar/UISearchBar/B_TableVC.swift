//
//  B_TableVC.swift
//  UISearchBar
//
//  Created by wangkan on 2016/11/1.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class B_TableVC: AppTableVC, UISearchBarDelegate {

    var originalSectionNames = [String]()
    var originalSectionData = [[String]]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // in this version, we take the total opposite approach:
        // we don't present any extra view at all!
        // we already have a table, so why not just filter the very same table?
        // to do so, pass nil as the search results controller,
        // and tell the search controller not to insert a dimming view
        
        // keep copies of the original data
        self.originalSectionData = self.sectionData
        self.originalSectionNames = self.sectionNames
        let searcher = AppSearchController(searchResultsController:nil)
        self.searcher = searcher
        searcher.dimsBackgroundDuringPresentation = false
        searcher.searchResultsUpdater = self
        searcher.delegate = self
        // put the search controller's search bar into the interface
        let b = searcher.searchBar
        addSearchBar(b)
    }
    
    // much nicer without section index during search
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return self.searching ? nil : self.sectionNames
//    }
}

extension B_TableVC : UISearchControllerDelegate {
    // flag for whoever needs it (in this case, sectionIndexTitles...)
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searching = true
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        self.searching = false
    }
}

extension B_TableVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let sb = searchController.searchBar
        let target = sb.text!
        if target == "" {
            self.sectionNames = self.originalSectionNames
            self.sectionData = self.originalSectionData
            self.tableView.reloadData()
            return
        }
        // we have a target string
        self.sectionData = self.originalSectionData.map {
            $0.filter {
                let options = NSString.CompareOptions.caseInsensitive
                let found = $0.range(of: target, options: options)
                return (found != nil)
            }
            }.filter {$0.count > 0} // is Swift cool or what?
        self.sectionNames = self.sectionData.map {String($0[0].characters.prefix(1))}
        self.tableView.reloadData()
    }
}


