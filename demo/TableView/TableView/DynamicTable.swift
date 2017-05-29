//
//  DynamicTableVC.swift
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

class DynamicTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var sectionNames = [String]()
    var sectionData = [[String]]()
    var hiddenSections = Set<Int>()
    var showSections = Set<Int>()
    fileprivate var tableView = UITableView()
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(
            MyHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.sectionIndexColor = UIColor.white
        tableView.sectionIndexBackgroundColor = UIColor.red
        tableView.sectionIndexTrackingBackgroundColor = UIColor.blue
        tableView.estimatedRowHeight = 30
        tableView.estimatedSectionHeaderHeight = 40
        
        let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!, encoding: String.Encoding.utf8)
        let states = s.components(separatedBy: "\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append(c.uppercased())
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
    
    override func viewDidAppear(_ animated: Bool = true) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showSections.contains(section) {
            return self.sectionData[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 40
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "Header") as! MyHeaderView
        if h.tintColor != UIColor.red {
            h.tintColor = UIColor.red // invisible marker, tee-hee
            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = UIColor.black
            let lab = UILabel()
            let lab1 = UILabel()
            lab.tag = 1
            lab.font = UIFont(name: "Georgia-Bold", size: 22)
            lab.textColor = UIColor.green
            lab.backgroundColor = UIColor.clear
            lab1.tag = 1
            lab1.font = UIFont(name: "Georgia-Bold", size: 22)
            lab1.textColor = UIColor.green
            lab1.backgroundColor = UIColor.clear
            h.contentView.addSubview(lab)
            let v = UIImageView()
            let v1 = UIImageView()
            v.tag = 2
            v.backgroundColor = UIColor.black
            v.image = UIImage(named: "us_flag_small.gif")
            v1.tag = 2
            v1.backgroundColor = UIColor.black
            v1.image = UIImage(named: "us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-5-[lab]-5-[v(40)]-10-|",
                    options: [], metrics: nil, views: ["v": v, "lab": lab]),
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[v]|",
                    options: [], metrics: nil, views: ["v": v]),
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[lab]|",
                    options: [], metrics: nil, views: ["lab": lab])
                ].joined().map { $0 })
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionNames
    }
    
    func tapped (_ g: UIGestureRecognizer) {
        let v = g.view as! MyHeaderView
        let sec = v.section
        let ct = self.sectionData[sec].count
        let arr = (0..<ct).map { IndexPath(row: $0, section: sec) } // whoa! ***
        if self.showSections.contains(sec) {
            self.showSections.remove(sec)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: arr, with: .automatic)
            self.tableView.endUpdates()
        } else {
            self.showSections.insert(sec)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: arr, with: .automatic)
            self.tableView.endUpdates()
            //Important: insertRows过多时,相当于一次性加载了所有的row,性能会受影响
            self.tableView.scrollToRow(at: arr[ct - 1],
                                                  at: .none,
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
