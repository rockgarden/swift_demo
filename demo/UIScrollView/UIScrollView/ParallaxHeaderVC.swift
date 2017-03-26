//
//  ViewController.swift
//  Parallaxscrollview
//
//  Created by wzh on 16/4/20.
//  Copyright © 2016年 谈超. All rights reserved.
//

import UIKit

class ParallaxHeaderVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let headerView = ParallaxHeader.creatParallaxScrollViewWithImage(image: UIImage(named: "img1")!, forSize: CGSize(width: tableView.bounds.width, height: 300),referView: tableView)
        tableView.tableHeaderView = headerView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (tableView.tableHeaderView as! ParallaxHeader).refreshBlurViewForNewImage()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        return cell!
    }

}

