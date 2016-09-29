//
//  ExpandableLabelVC.swift
//  UILabel
//
//  Created by wangkan on 2016/9/29.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ExpandableLabelVC: UIViewController {
    @IBOutlet weak var headerTitleView: UIView!
    var tableView: UITableView!
    var tableViewController = UITableViewController(style: .Grouped)
    var refreshControl = UIRefreshControl()
    var stackView = UIStackView() {
        didSet {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .Vertical
            stackView.distribution = .Fill
            stackView.alignment = .Center
            stackView.spacing = 10.0
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: stackView.spacing, bottom: 0, right: stackView.spacing)
            stackView.layoutMarginsRelativeArrangement = true
        }
    }
    let numberOfCells : NSInteger = 10
    var states : Array<Bool>!
    //    var expandableLabel: ExpandableLabel! {
    //        didSet {
    //            expandableLabel.translatesAutoresizingMaskIntoConstraints = false
    //            expandableLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
    //            expandableLabel.textColor = .whiteColor()
    //            expandableLabel.textAlignment = .Center
    //            expandableLabel.setContentHuggingPriority(249, forAxis: .Horizontal)
    //            expandableLabel.setContentCompressionResistancePriority(500, forAxis: .Horizontal)
    //        }
    //    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        states = [Bool](count: numberOfCells, repeatedValue: true)
        setupStackView()
        setupTableView()
        self.view.addSubview(stackView)
        self.view.addSubview(tableView)
        setConstraints()
    }
    
    // MARK: - SETUP VIEW
    private func setupStackView() {
        stackView.frame = CGRectMake(0, 0, 200, 62)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Center
        stackView.spacing = 10.0
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: stackView.spacing, bottom: 0, right: stackView.spacing)
        stackView.layoutMarginsRelativeArrangement = true
    }
    
    private func setupTableView() {
        tableView = tableViewController.tableView
        tableView.backgroundColor = .clearColor()
        tableView.registerNib(UINib(nibName: "ExpandCell", bundle: nil), forCellReuseIdentifier: "ExpandCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30.0
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activateConstraints([
            tableView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor),
            tableView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor),
            tableView.topAnchor.constraintEqualToAnchor(stackView.bottomAnchor),
            tableView.bottomAnchor.constraintEqualToAnchor(self.bottomLayoutGuide.topAnchor),
            stackView.topAnchor.constraintEqualToAnchor(headerTitleView.bottomAnchor),
            stackView.bottomAnchor.constraintEqualToAnchor(tableView.topAnchor),
            stackView.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor),
            stackView.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...2 {
            guard let v = View_KV.newInstance() else {return}
            v.configureItem(String(i), value: loremIpsumText())
            let label = ExpandableLabel(frame: CGRectMake(0,0,60,20))
            label.delegate = self
            label.text = loremIpsumText()
            label.numberOfLines = 2
            label.collapsed = true
            stackView.addArrangedSubview(v)
            stackView.addArrangedSubview(label)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func loremIpsumText() -> String {
        return "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    }
}

extension ExpandableLabelVC: ExpandableLabelDelegate {
    func willExpandLabel(label: ExpandableLabel) {
        //        tableView.beginUpdates()
    }
    
    func didExpandLabel(label: ExpandableLabel) {
        //        let point = label.convertPoint(CGPointZero, toView: tableView)
        //        if let indexPath = tableView.indexPathForRowAtPoint(point) as NSIndexPath? {
        //            states[indexPath.row] = false
        //        }
        //        tableView.endUpdates()
    }
    
    func willCollapseLabel(label: ExpandableLabel) {
        //        tableView.beginUpdates()
    }
    
    func didCollapseLabel(label: ExpandableLabel) {
        //        let point = label.convertPoint(CGPointZero, toView: tableView)
        //        if let indexPath = tableView.indexPathForRowAtPoint(point) as NSIndexPath? {
        //            states[indexPath.row] = true
        //        }
        //        tableView.endUpdates()
    }
    
    func shouldCollapseLabel(label: ExpandableLabel) -> Bool {
        return true
    }
}

extension ExpandableLabelVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExpandCell") as! ExpandCell
        //        cell.expandableLabel.delegate = self
        cell.expandableLabel.numberOfLines = 3
        cell.expandableLabel.collapsed = states[indexPath.row]
        cell.expandableLabel.text = loremIpsumText()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
}


extension UIView {
    class func fromNib <T : UIView> () -> T {
        return NSBundle.mainBundle().loadNibNamed(String(T), owner: nil, options: nil)[0] as! T
    }
}
