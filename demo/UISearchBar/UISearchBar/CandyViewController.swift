//
//  CandyViewController.swift
//  013-UISearchBar
//
//  Created by Audrey Li on 4/6/15.
//  Copyright (c) 2015 com.shomigo. All rights reserved.
//

import UIKit

class CandyViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var data = [Candy]()
    var filteredData = [Candy]()
    
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
        
        filteredData = data
        
        
        

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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filterContentForSearchText(searchText)
        } else {
            filteredData = data
        }
        self.collectionView.reloadData()
    }
    
    
    
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coCell", for: indexPath) as! CollectionViewCell
        
        cell.textLabel.text = filteredData[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    
    

}
