//
//  ExpandableLabelVC.swift
//  UILabel
//
//  Created by wangkan on 2016/9/29.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ExpandableLabelVC: UIViewController {

    var tableView: UITableView!
    var tableViewController = UITableViewController(style: .grouped)
    var refreshControl = UIRefreshControl()
    var stackView = UIStackView() {
        didSet {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 10.0
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: stackView.spacing, bottom: 0, right: stackView.spacing)
            stackView.isLayoutMarginsRelativeArrangement = true
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
        states = [Bool](repeating: true, count: numberOfCells)
        setupStackView()
        setupTableView()
        self.view.addSubview(stackView)
        self.view.addSubview(tableView)
        setConstraints()
    }
    
    // MARK: - SETUP VIEW
    fileprivate func setupStackView() {
        stackView.frame = CGRect(x: 0, y: 0, width: 200, height: 62)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10.0
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: stackView.spacing, bottom: 0, right: stackView.spacing)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    fileprivate func setupTableView() {
        tableView = tableViewController.tableView
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "ExpandCell", bundle: nil), forCellReuseIdentifier: "ExpandCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
            stackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...1 {
            guard let v = View_KV.newInstance() else {return}
            v.configureItem(String(i), value: shortText())
            let label = ExpandableLabel(frame: CGRect(x: 0,y: 0,width: 60,height: 20))
            label.delegate = self
            label.text = loremIpsumText()
            label.numberOfLines = 2
            label.collapsed = true
            stackView.addArrangedSubview(v)
            stackView.addArrangedSubview(label)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func loremIpsumText() -> String {
        return "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    }

    func shortText() -> String {
        return "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. "
    }
}


extension ExpandableLabelVC: ExpandableLabelDelegate {

    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as NSIndexPath? {
            states[indexPath.row] = false
        }
        tableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as NSIndexPath? {
            states[indexPath.row] = true
        }
        tableView.endUpdates()
    }
    
    func shouldCollapseLabel(_ label: ExpandableLabel) -> Bool {
        return true
    }
}

extension ExpandableLabelVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandCell
        cell.expandableLabel.delegate = self
        cell.expandableLabel.numberOfLines = 3
        cell.expandableLabel.collapsed = states[(indexPath as NSIndexPath).row]
        cell.expandableLabel.text = loremIpsumText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
}

