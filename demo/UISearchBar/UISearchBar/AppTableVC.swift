//
//  AppTableVC.swift
//  UISearchBar
//
//  Created by wangkan on 2017/6/7.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class AppTableVC: UITableViewController {

    var sectionNames = [String]()
    var sectionData = [[String]]()
    var searcher: UISearchController!

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //automaticallyAdjustsScrollViewInsets = false

        prepareData(sectionNames: &sectionNames, cellData: &sectionData)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")

        tableView.sectionIndexColor = .white
        tableView.sectionIndexBackgroundColor = .red
        tableView.sectionIndexTrackingBackgroundColor = .blue
        tableView.backgroundColor = .yellow //search bar covers that
        tableView.estimatedSectionHeaderHeight = 60

        tableView.backgroundView = { // this will fix it
            let v = UIView()
            v.backgroundColor = .yellow
            return v
        }()
    }

    // put the search controller's search bar into the interface
    func addSearchBar(_ b: UISearchBar ) {
        b.autocapitalizationType = .none
        b.sizeToFit()
        tableView.tableHeaderView = b
        tableView.reloadData()
        tableView.contentOffset = CGPoint(0,b.frame.height)
        // FIXME: 实现 scroll To SectionHeader
        //        self.tableView.scrollToRow(
        //            at: IndexPath(row: 0, section: 0),
        //            at:.top, animated:false)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let s = self.sectionData[indexPath.section][indexPath.row]
        cell.textLabel!.text = s

        var stateName = s
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of: " ", with: "")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        return cell
    }

    /*
     override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
     return self.sectionNames[section]
     }
     */

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")!
        if h.viewWithTag(1) == nil { //h.tintColor != .red;h.tintColor = .red
            h.backgroundView = UIView()
            h.backgroundView!.backgroundColor = .black
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name: "Georgia-Bold", size: 22)
            lab.textColor = .green
            lab.backgroundColor = .clear
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = .black
            v.image = UIImage(named: "us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lab(25)]-10-[v(40)]",
                                               options: [], metrics: nil, views: ["v": v, "lab": lab]),
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|",
                                               options: [], metrics: nil, views: ["v": v]),
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[lab]|",
                                               options: [], metrics: nil, views: ["lab": lab])
                ].joined().map { $0 })
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        return h
    }

    /*
     override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
     print(view) // prove we are reusing header views
     }
     */

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
    
}
