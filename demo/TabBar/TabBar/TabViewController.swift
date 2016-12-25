//
//  TabViewController.swift
//  TabBar
//
//  Created by wangkan on 16/8/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//
//  Example: use UITabBar and UITabBarDelegate no subClass

import UIKit

class TabViewController: UIViewController {
	@IBOutlet var tabbar: UITabBar!
	var items: [UITabBarItem] = {
		Array(1..<8).map {
			UITabBarItem(
				tabBarSystemItem: UITabBarSystemItem(rawValue: $0)!, tag: $0)
		}
	}()

    //TODO: 如何通过UITabBarItem显示VC
	fileprivate var _vcs: [UIViewController] = []
	var vcs: [UIViewController] {
		get {
			return _vcs // 在类里加self._p
		}
		set {
			for t in arr {
				let vc = SubVC()
				vc.tabBarItem.title = t
				_vcs.append(vc)
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabbar.items = Array(self.items[0..<4]) + [UITabBarItem(tabBarSystemItem: .more, tag: 0)]
		self.tabbar.selectedItem = self.tabbar.items![0]
        self.tabbar.delegate = self //Storyboard已经设置可不写
	}
}

extension TabViewController: UITabBarDelegate {

	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		print("did select item with tag \(item.tag)")
		if item.tag == 0 {
			// More button
			tabBar.selectedItem = nil
			tabBar.beginCustomizingItems(self.items)
		}
	}

	func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
		self.tabbar.selectedItem = self.tabbar.items![0]
	}
}
