//
//  CandyNewTableViewController.swift
//  UISearchBar
//
//  Created by Audrey Li on 4/7/15.
//  Copyright (c) 2015 com.shomigo. All rights reserved.
//

import UIKit


class CandyNewTableViewController: UITableViewController, UISearchResultsUpdating {

    var data = [Candy]()
    var filteredData = [Candy]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.data = [Candy(category:"Chocolate", name:"chocolate Bar"),
            Candy(category:"Chocolate", name:"chocolate Chip"),
            Candy(category:"Chocolate", name:"dark chocolate"),
            Candy(category:"Hard", name:"lollipop"),
            Candy(category:"Hard", name:"candy cane"),
            Candy(category:"Hard", name:"jaw breaker"),
            Candy(category:"Other", name:"caramel"),
            Candy(category:"Other", name:"sour chew"),
            Candy(category:"Other", name:"gummi bear")]

        
        self.resultSearchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false  // default true
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        }()
        
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredData = data.filter{ $0.name.range(of: searchController.searchBar.text!) != nil }
       
        self.tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredData.count
        }else {
            return self.data.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as UITableViewCell
        
        var candy: Candy
        if self.resultSearchController.isActive {
            candy = filteredData[(indexPath as NSIndexPath).row]
        } else {
           candy = data[(indexPath as NSIndexPath).row]
        }
        
        cell.textLabel?.text = candy.name

        return cell
    }
  
}
