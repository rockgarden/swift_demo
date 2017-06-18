//
//  AppUIPageVC.swift
//  UIPageControlDemo
//
//  Created by wangkan on 2017/6/18.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class AppUIPageVC: UIViewController, UIPageViewControllerDataSource {

    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
        let boy = (vc as! Person).boy
        let ix = pep.index(of:boy)! + 1
        if ix >= pep.count {
            return nil
        }
        return Person(pepBoy: pep[ix])
    }

    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
        let boy = (vc as! Person).boy
        let ix = pep.index(of:boy)! - 1
        if ix < 0 {
            return nil
        }
        return Person(pepBoy: pep[ix])
    }

    /// if these methods are implemented, page indicator appears

    func presentationCount(for pvc: UIPageViewController) -> Int {
        return pep.count
    }

    func presentationIndex(for pvc: UIPageViewController) -> Int {
        let page = pvc.viewControllers![0] as! Person
        let boy = page.boy
        return pep.index(of:boy)!
    }

}
