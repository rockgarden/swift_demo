//
//  TableViewDataSource.swift
//  示例自定义UITableViewDataSource
//


import UIKit

typealias TableViewCellConfigureBlock = (_ cell: UITableViewCell, _ item: AnyObject?) -> ()

class TableViewDataSource: NSObject, UITableViewDataSource {
    var items: Array = [Any]()
    var itemIdentifier: String?
    var configureCellBlock: TableViewCellConfigureBlock?
    
    init(items: Array<Any>, cellIdentifier: String, configureBlock: @escaping TableViewCellConfigureBlock){
        self.items = items
        self.itemIdentifier = cellIdentifier
        self.configureCellBlock = configureBlock
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemIdentifier!, for: indexPath) as UITableViewCell
        let item: AnyObject = itemAtIndexPath(indexPath)
        
        if (self.configureCellBlock != nil) {
            self.configureCellBlock!(cell, item)
        }
        
        return cell
    }

    func itemAtIndexPath(_ indexPath: IndexPath) -> AnyObject {
        return self.items[indexPath.row] as AnyObject
    }
    
}
