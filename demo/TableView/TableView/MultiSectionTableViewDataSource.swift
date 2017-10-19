//
//  TableViewDataSource.swift
//  示例自定义具有分段的UITableViewDataSource
//

// 伪代码
//dataSource = MultiSectionTableViewDataSource(items: Array, cellIdentifier: String, configureBlock: { (cell, item) -> () in
//    if let actualCell = cell as? CustomTableViewCell {
//        actualCell.configureForItem(item!)
//    }
//})
//
//tableView.dataSource = self.dataSource
//tableView.delegate = self.dataSource

import UIKit

class MultiSectionTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var items: [[AnyObject]]!
    var keys: [String]!
    
    var itemIdentifier: String!
    var configureCellBlock: TableViewCellConfigureBlock?
    
    init(items: [String: [AnyObject]], cellIdentifier: String, configureBlock: @escaping TableViewCellConfigureBlock){
        self.itemIdentifier = cellIdentifier
        self.configureCellBlock = configureBlock
        
        for (K,V) in items {
            if keys == nil {
                self.items = [V]
                self.keys = [K]
            } else {
                self.keys.append(K)
                self.items.append(V)
            }
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
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
        return self.items[indexPath.section][indexPath.row]
    }
    
    // viewForFooterInSection is a delegate method 
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = UIColor.white
        return footerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(keys[section])"
    }
}
