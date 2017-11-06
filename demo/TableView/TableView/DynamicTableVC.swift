//
//  DynamicTableVC.swift
//  TableView
//
//  Created by wangkan on 16/9/12.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

private class MyHeaderView: UITableViewHeaderFooterView {
    var section = 0
    deinit {
        print ("farewell from a header, section \(section)")
    }
}


class DynamicTableVC : AppTableVC {

    var hiddenSections = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(
            MyHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")

        //return // just testing reuse
        delay(5) {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        return self.sectionData[section].count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView
            .dequeueReusableHeaderFooterView(withIdentifier:"Header") as! MyHeaderView
        if h.gestureRecognizers == nil {
            print("nil")

            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = .black

            let lab = UILabel()
            lab.tag = 11111
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = .green
            lab.backgroundColor = .clear
            h.contentView.addSubview(lab)

            let v = UIImageView()
            v.tag = section
            v.backgroundColor = .black
            v.image = UIImage(named:"us_flag_small.gif")
            h.contentView.addSubview(v)

            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:|-5-[lab(25)]-10-[v(40)]",
                                               metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[v]|",
                                               metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[lab]|",
                                               metrics:nil, views:["lab":lab])
                ].flatMap{$0})

            // add tap g.r.
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped)) // *
            tap.numberOfTapsRequired = 2
            h.addGestureRecognizer(tap)
            // TODO: add tap to v, send section by v.tap
        }
        let lab = h.contentView.viewWithTag(11111) as! UILabel
        lab.text = self.sectionNames[section]
        h.section = section
        return h
    }

    @objc func tapped (_ g : UIGestureRecognizer) {
        let v = g.view as! MyHeaderView
        let sec = v.section
        let ct = self.sectionData[sec].count
        let arr = (0..<ct).map {IndexPath(row:$0, section:sec)}
        if self.hiddenSections.contains(sec) {
            self.hiddenSections.remove(sec)
            self.tableView.beginUpdates()
            //Important: insertRows过多时,相当于一次性加载了所有的row,性能会受影响
            self.tableView.insertRows(at:arr, with:.automatic)
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at:arr[ct-1], at:.none, animated:true)
        } else {
            self.hiddenSections.insert(sec)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at:arr, with:.automatic)
            self.tableView.endUpdates()
        }
        
    }
}


/// 伪代码 示例 UIViewController -> UITableViewController
private class DynamicTable: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(
            MyHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.sectionIndexColor = UIColor.white
        tableView.sectionIndexBackgroundColor = UIColor.red
        tableView.sectionIndexTrackingBackgroundColor = UIColor.blue
        tableView.estimatedRowHeight = 30
        tableView.estimatedSectionHeaderHeight = 40
        
        /*
         同上
         prepare data
         */

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showSections.contains(section) {
            return self.sectionData[section].count
        }
        return 0
    }

    /*
     同上
     func numberOfSections(in tableView: UITableView) -> Int
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
     func sectionIndexTitles(for tableView: UITableView) -> [String]?
     func tapped (_ g: UIGestureRecognizer)
     */

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
