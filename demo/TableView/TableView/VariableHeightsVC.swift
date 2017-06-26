//
//  VariableHeightsVC.swift
//  TableView
//
//  Created by wangkan on 2016/11/7.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class Cell : UITableViewCell {
    @IBOutlet weak var lab : UILabel!
    @IBOutlet weak var lab1: UILabel!
}

class VariableHeightsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var trivia : [String]!
    @IBOutlet weak var tableView: UITableView!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 基于NIB so no setup
        //tableView = UITableView(frame: self.view.bounds)
        //tableView.delegate = self
        //tableView.dataSource = self

        let url = Bundle.main.url(forResource: "trivia", withExtension: "txt")
        let s = try! String(contentsOf:url!, encoding: String.Encoding.utf8)
        var arr = s.components(separatedBy: "\n")
        debugPrint(arr[arr.count-1])
        arr.removeLast()
        self.trivia = arr
        
        self.tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = UITableViewAutomaticDimension // not actually necessary
        self.tableView.estimatedRowHeight = 40 // turn on automatic cell variable sizing!
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trivia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.backgroundColor = UIColor.white
        cell.lab.text = self.trivia[indexPath.row]
        cell.lab1.text = self.trivia[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated:false)
            return nil
        }
        return indexPath
    }
    
}
