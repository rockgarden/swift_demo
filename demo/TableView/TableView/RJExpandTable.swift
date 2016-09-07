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
            tableView.registerClass(SubCell.self, forCellReuseIdentifier: "SubCell")
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            tableView.tableFooterView = UIView(frame: CGRectZero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func animateTable() {
        self.tableView.reloadData()
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            index += 1
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SubCell", forIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = "subcell\(indexPath.section)-\(indexPath.row)"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor =  colorforIndex(indexPath.section)
    }
    
    func colorforIndex(index: Int) -> UIColor {
        let itemCount = 10 - 1
        let color = (CGFloat(index) / CGFloat(itemCount))
        return UIColor(red: color, green: color, blue: 0.3, alpha: 1.0)
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
