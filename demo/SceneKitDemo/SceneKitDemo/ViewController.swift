//
//  ViewController.swift
//  SceneKitDemo
//
//  Created by wangkan on 2017/5/12.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var cylinderChartSceneController:SceneViewController!
    var cubeChartSceneController:SceneViewController!
    var pieChartSceneController:SceneViewController!
    
    let chartTypes:[String] = ["Cylinder Charts", "Cube Charts", "Pie Charts"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chart Types"
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = CGRect.zero
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        // Create a bottom space constraint
        var constraint = NSLayoutConstraint (item: tableView,
                                             attribute: NSLayoutAttribute.bottom,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: self.view,
                                             attribute: NSLayoutAttribute.bottom,
                                             multiplier: 1,
                                             constant: 0)
        self.view.addConstraint(constraint)
        // Create a top space constraint
        constraint = NSLayoutConstraint (item: tableView,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutAttribute.top,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        // Create a right space constraint
        constraint = NSLayoutConstraint (item: tableView,
                                         attribute: NSLayoutAttribute.right,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutAttribute.right,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        // Create a left space constraint
        constraint = NSLayoutConstraint (item: tableView,
                                         attribute: NSLayoutAttribute.left,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutAttribute.left,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        
        cylinderChartSceneController = SceneViewController(type:ChartType.cylinder)
        cubeChartSceneController = SceneViewController(type:ChartType.cube)
        pieChartSceneController = SceneViewController(type:ChartType.pie)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CellIdentifier)
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        let cellText = chartTypes[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = cellText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).row == 0) {
            self.navigationController?.pushViewController(cylinderChartSceneController, animated: false)
        } else if((indexPath as NSIndexPath).row == 1) {
            self.navigationController?.pushViewController(cubeChartSceneController, animated:false)
        } else {
            self.navigationController?.pushViewController(pieChartSceneController, animated:false)
        }
    }
    
}

