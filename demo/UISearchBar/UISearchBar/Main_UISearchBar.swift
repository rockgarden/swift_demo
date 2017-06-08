//
//  Main_UISearchBar.swift
//  UISearchBar
//
//  Created by wangkan on 2017/6/7.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_UISearchBar: UITableViewController {

    let sectionHeaders = ["TableView",
                          "CollectionView",
                          "UISearchBar",
                          ]
    var sectionTitles = [[String]]()
    var sectionSampleClasses: Array<Array<UIViewController.Type>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
        initTableData()
        setupTableView()
    }

    func initTableData() {
        let section1 = ["Base SearchResultsController",
                        "实现 UISearchControllerDelegate",
                        "使用相同的视图控制器显示可搜索的内容和搜索结果",
                        "Put search bar into navigation bar",
                        "Use SearchResultsController Container",
                        "Popover SearchResultsController",
                        ]
        let section1_class = [SearchResultsControllerVC.self,
                              UISearchControllerDelegateVC.self,
                              SameVC.self,
                              SearchBarInNavigationBarVC.self,
                              ContainerVC.self,
                              PopoverVC.self,
                              ]

        let section3 = ["UISearchBar symbols",
                        ]
        let section3_class = [UISearchBarVC.self,
                              ]

        sectionTitles = [section1,section1,section3]
        sectionSampleClasses = [section1_class,section1_class,section3_class]
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        //tableView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        //tableView.delegate = self
        //tableView.dataSource = self
        //view.addSubview(tableView)
    }


    //MARK:- TableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)

        let section = self.sectionTitles[indexPath.section]
        let rowTitle = section[indexPath.row]

        let section_Class = self.sectionSampleClasses[indexPath.section]
        let vcClass = section_Class[indexPath.row]

        let vcInstance = vcClass.init()
        vcInstance.title = rowTitle

        self.navigationController?.pushViewController(vcInstance, animated: true)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDef = self.sectionTitles[section]
        return sectionDef.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.0
    }

    //MARK:- TableViewDataSource
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "demoCellIdentifier"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }

        let section = self.sectionTitles[indexPath.section]
        let rowTitle = section[indexPath.row]

        let section_Class = self.sectionSampleClasses[indexPath.section]
        let className = section_Class[indexPath.row]

        cell!.textLabel?.text = rowTitle
        cell!.detailTextLabel?.text = String(describing: className)
        
        return cell!
    }
    
}
