//
//  DynamicTable.swift
//  TableView
//
//  Created by wangkan on 16/9/12.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class MyHeaderView: UITableViewHeaderFooterView {
    var section = 0
    deinit {
        print ("farewell from a header, section \(section)")
    }
}

class DynamicTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var hiddenSections = Set<Int>()
    var showSections = Set<Int>()
    private var tableView = UITableView()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerClass(
            MyHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.sectionIndexColor = UIColor.whiteColor()
        tableView.sectionIndexBackgroundColor = UIColor.redColor()
        tableView.sectionIndexTrackingBackgroundColor = UIColor.blueColor()
        tableView.estimatedRowHeight = 30
        tableView.estimatedSectionHeaderHeight = 40
        
        let s = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let states = s.componentsSeparatedByString("\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append(c.uppercaseString)
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append([String]())
            }
            sectionData[sectionData.count - 1].append(aState)
        }
        for i in 0..<sectionNames.count {
            hiddenSections.insert(i)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool = true) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showSections.contains(section) {
            return self.sectionData[section].count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let s = self.sectionData[indexPath.section][indexPath.row]
        cell.textLabel!.text = s
        var stateName = s
        stateName = stateName.lowercaseString
        stateName = stateName.stringByReplacingOccurrencesOfString(" ", withString: "")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 40
    //    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterViewWithIdentifier("Header") as! MyHeaderView
        if h.tintColor != UIColor.redColor() {
            h.tintColor = UIColor.redColor() // invisible marker, tee-hee
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = UIColor.blackColor()
            let lab = UILabel()
            let lab1 = UILabel()
            lab.tag = 1
            lab.font = UIFont(name: "Georgia-Bold", size: 22)
            lab.textColor = UIColor.greenColor()
            lab.backgroundColor = UIColor.clearColor()
            lab1.tag = 1
            lab1.font = UIFont(name: "Georgia-Bold", size: 22)
            lab1.textColor = UIColor.greenColor()
            lab1.backgroundColor = UIColor.clearColor()
            h.contentView.addSubview(lab)
            let v = UIImageView()
            let v1 = UIImageView()
            v.tag = 2
            v.backgroundColor = UIColor.blackColor()
            v.image = UIImage(named: "us_flag_small.gif")
            v1.tag = 2
            v1.backgroundColor = UIColor.blackColor()
            v1.image = UIImage(named: "us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activateConstraints([
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|-5-[lab]-5-[v(40)]-10-|",
                    options: [], metrics: nil, views: ["v": v, "lab": lab]),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[v]|",
                    options: [], metrics: nil, views: ["v": v]),
                NSLayoutConstraint.constraintsWithVisualFormat(
                    "V:|[lab]|",
                    options: [], metrics: nil, views: ["lab": lab])
                ].flatten().map { $0 })
            // add tap g.r.
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped)) // *
            tap.numberOfTapsRequired = 2
            h.addGestureRecognizer(tap)
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        h.section = section // *
        return h
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
    
    func tapped (g: UIGestureRecognizer) {
        let v = g.view as! MyHeaderView
        let sec = v.section
        let ct = self.sectionData[sec].count
        let arr = (0..<ct).map { NSIndexPath(forRow: $0, inSection: sec) } // whoa! ***
        if self.showSections.contains(sec) {
            self.showSections.remove(sec)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths(arr,
                                                  withRowAnimation: .Automatic)
            self.tableView.endUpdates()
        } else {
            self.showSections.insert(sec)
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(arr,
                                                  withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            self.tableView.scrollToRowAtIndexPath(arr[ct - 1],
                                                  atScrollPosition: .None,
                                                  animated: true)
        }
        //        if self.hiddenSections.contains(sec) {
        //            self.hiddenSections.remove(sec)
        //            self.tableView.beginUpdates()
        //            self.tableView.insertRowsAtIndexPaths(arr,
        //                                                  withRowAnimation: .Automatic)
        //            self.tableView.endUpdates()
        //            self.tableView.scrollToRowAtIndexPath(arr[ct - 1],
        //                                                  atScrollPosition: .None,
        //                                                  animated: true)
        //        } else {
        //            self.hiddenSections.insert(sec)
        //            self.tableView.beginUpdates()
        //            self.tableView.deleteRowsAtIndexPaths(arr,
        //                                                  withRowAnimation: .Automatic)
        //            self.tableView.endUpdates()
        //        }
        
    }
    
}
