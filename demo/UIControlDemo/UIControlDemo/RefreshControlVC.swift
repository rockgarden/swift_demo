//
//  RefreshControlVC.swift
//  UIControlDemo
//
//  Created by wangkan on 2017/5/17.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class RefreshControlVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifer = "NewCellIdentifier"
    
    let favoriteEmoji = ["🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆","🏃🏃🏃🏃🏃", "💩💩💩💩💩", "👸👸👸👸👸", "🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆"]
    let newFavoriteEmoji = ["🏃🏃🏃🏃🏃", "💩💩💩💩💩", "👸👸👸👸👸", "🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆"]
    var emojiData = [String]()
    var emojiTableView: UITableView!
    var tableViewController = UITableViewController(style: .grouped)
    var refreshControl = UIRefreshControl()
    // var navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 375, height: 64))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "emoji"
        // self.navBar.barStyle = UIBarStyle.BlackTranslucent
        // self.view.addSubview(navBar)
        emojiTableView = tableViewController.tableView
        emojiData = favoriteEmoji
        
        emojiTableView.backgroundColor = UIColor(red: 0.092, green: 0.096, blue: 0.116, alpha: 1)
        emojiTableView.dataSource = self
        emojiTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
        emojiTableView.rowHeight = UITableViewAutomaticDimension
        emojiTableView.estimatedRowHeight = 60.0
        emojiTableView.tableFooterView = UIView(frame: CGRect.zero)
        emojiTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        emojiTableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewController.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(didRoadEmoji), for: .valueChanged)
        self.refreshControl.backgroundColor = UIColor(red: 0.113, green: 0.113, blue: 0.145, alpha: 1)
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(Date())", attributes: attributes)
        self.refreshControl.tintColor = UIColor.white
        
        self.view.addSubview(emojiTableView)
        
        NSLayoutConstraint.activate([
            emojiTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            emojiTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emojiTableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            emojiTableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor)
            ])
    }
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer)! as UITableViewCell
        cell.textLabel!.text = self.emojiData[(indexPath as NSIndexPath).row]
        cell.textLabel!.textAlignment = NSTextAlignment.center
        cell.textLabel!.font = UIFont.systemFont(ofSize: 50)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.beginRefreshing() // 无效无动画
    }
    
    // RoadEmoji
    func didRoadEmoji() {
        emojiData = newFavoriteEmoji
        animateTable(emojiTableView)
        refreshControl.endRefreshing()
    }
    
    func animateTable(_ table: UITableView) {
        table.reloadData()
        let cells = table.visibleCells
        let tableHeight: CGFloat = table.bounds.size.height
        for c in cells {
            let cell = c as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for c in cells {
            let cell = c as UITableViewCell
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
    
}

