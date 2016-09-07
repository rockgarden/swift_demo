//
//  RJExpandTableswift.swift
//  TableView
//
//  Created by wangkan on 16/9/7.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class RJExpandTable: UIViewController {
    
    let expandCellId = "ExpandTableViewCell"
    
    @IBOutlet weak var tableView: RJExpandableTableView! {
        didSet {
            tableView.registerNib(UINib(nibName: expandCellId, bundle: nil), forCellReuseIdentifier: expandCellId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension RJExpandTable: RJExpandableTableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: RJExpandableTableView, canExpandInSection section: Int) -> Bool {
        return true
    }
    
    func tableView(tableView: RJExpandableTableView, needsToDownloadDataForExpandSection section: Int) -> Bool {
        return true
    }
    
    func tableView(tableView: RJExpandableTableView, expandingCellForSection section: Int) -> RJExpandingTableViewCell {
        let expandCell = tableView.dequeueReusableCellWithIdentifier(expandCellId) as! ExpandTableViewCell
        return expandCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "subCell")
        cell.textLabel?.text = "subcell\(indexPath.section)-\(indexPath.row)"
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
}

extension RJExpandTable: RJExpandableTableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: RJExpandableTableView, heightForExpandingCellAtSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: RJExpandableTableView, downloadDataForExpandableSection section: Int) {
        
        delay(2) {
            if section % 2 == 0 {
                tableView.expandSection(section, animated: true)
            } else {
                print("Download failed!")
                tableView.cancelDownloadInSection(section)
            }
        }
    }
}

/**
 Helper for delay
 
 - parameter time: <#time description#>
 - parameter work: <#work description#>
 */
func delay(time: NSTimeInterval, work: dispatch_block_t) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        work()
    }
}
