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
            tableView.register(UINib(nibName: expandCellId, bundle: nil), forCellReuseIdentifier: expandCellId)
            tableView.register(SubCell.self, forCellReuseIdentifier: "SubCell")
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            index += 1
        }
    }
    
}

extension RJExpandTable: RJExpandableTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: RJExpandableTableView, canExpandInSection section: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: RJExpandableTableView, needsToDownloadDataForExpandSection section: Int) -> Bool {
        return false
    }
    
    func tableView(_ tableView: RJExpandableTableView, expandingCellForSection section: Int) -> RJExpandingTableViewCell {
        let expandCell = tableView.dequeueReusableCell(withIdentifier: expandCellId) as! ExpandTableViewCell
        return expandCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.text = "subcell\(indexPath.section)-\(indexPath.row)"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
}

extension RJExpandTable: RJExpandableTableViewDelegate {

    @objc(tableView:heightForRowAtIndexPath:) public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: RJExpandableTableView, heightForExpandingCellAtSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: RJExpandableTableView, downloadDataForExpandableSection section: Int) {
        delay(0) {
            if section % 2 == 0 {
                tableView.expandSection(section, animated: true)
            } else {
                print("Download failed!")
                tableView.cancelDownloadInSection(section)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor =  colorforIndex(indexPath.section)
    }
    
    func colorforIndex(_ index: Int) -> UIColor {
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
func delay(_ time: TimeInterval, work: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        work()
    }
}
