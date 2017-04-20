//
//  TabPageVC.swift
//  UIPageControlDemo
//
//  Created by wangkan on 2017/4/20.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class TabPageVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIButton(frame: CGRect(x: 40, y: 80, width: 100, height: 40))
        button1.setTitle("Limited", for: UIControlState())
        button1.addTarget(self, action: #selector(LimitedButton(_:)), for: .touchUpInside)
        
        let button2 = UIButton(frame: CGRect(x: 40, y: 160, width: 100, height: 40))
        button2.setTitle("Infinity", for: UIControlState())
        button2.addTarget(self, action: #selector(InfinityButton(_:)), for: .touchUpInside)
        
        view.addSubview(button1)
        view.addSubview(button2)
    }
    
    func LimitedButton(_ button: UIButton) {
        let tc = TabPageViewController()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.white
        let vc2 = ListViewController()
        tc.tabItems = [(vc1, "First"), (vc2, "Second")]
        var option = TabPageOption()
        option.tabWidth = view.frame.width / CGFloat(tc.tabItems.count)
        option.hidesTopViewOnSwipeType = .all
        tc.option = option
        navigationController?.pushViewController(tc, animated: true)
    }
    
    func InfinityButton(_ button: UIButton) {
        let tc = TabPageViewController()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor(red: 251/255, green: 252/255, blue: 149/255, alpha: 1.0)
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor(red: 252/255, green: 150/255, blue: 149/255, alpha: 1.0)
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor(red: 149/255, green: 218/255, blue: 252/255, alpha: 1.0)
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor(red: 149/255, green: 252/255, blue: 197/255, alpha: 1.0)
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor(red: 252/255, green: 182/255, blue: 106/255, alpha: 1.0)
        tc.tabItems = [(vc1, "Mon."), (vc2, "Tue."), (vc3, "Wed."), (vc4, "Thu."), (vc5, "Fri.")]
        tc.isInfinity = true
        let nc = UINavigationController()
        nc.viewControllers = [tc]
        var option = TabPageOption()
        option.currentColor = UIColor(red: 246/255, green: 175/255, blue: 32/255, alpha: 1.0)
        option.tabMargin = 30.0
        tc.option = option
        navigationController?.pushViewController(tc, animated: true)
    }
}


internal class ListViewController: UITableViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navigationHeight = topLayoutGuide.length
        tableView.contentInset.top = navigationHeight + TabPageOption().tabHeight
    }
    
    fileprivate func updateNavigationBarOrigin(velocity: CGPoint) {
        guard let tabPageViewController = parent as? TabPageViewController else { return }
        
        if velocity.y > 0.5 {
            tabPageViewController.updateNavigationBarHidden(true, animated: true)
        } else if velocity.y < -0.5 {
            tabPageViewController.updateNavigationBarHidden(false, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = String((indexPath as NSIndexPath).row)
        return cell
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        updateNavigationBarOrigin(velocity: velocity)
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let tabpageViewController = parent as? TabPageViewController else { return }
        tabpageViewController.showNavigationBar()
    }
}

