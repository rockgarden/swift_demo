//
//  UIPageViewControllerDemo.swift
//  UIPageControlDemo
//
//  Created by wangkan on 2017/2/24.
//  Copyright © 2017年 rockgarden. All rights reserved.
//


import UIKit

class UIPageViewControllerDemo: UIViewController, UIPageViewControllerDataSource {

    weak var pageViewController : UIPageViewController!
    let pep : [String] = ["Manny", "Moe", "Jack"]


    override func viewDidLoad() {
        super.viewDidLoad()

        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.6)
        proxy.currentPageIndicatorTintColor = .red
        proxy.backgroundColor = .yellow


        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pvc.dataSource = self
        self.addChildViewController(pvc)
        self.view.addSubview(pvc.view)

        let (_,f) = self.view.bounds.divided(atDistance: 50, from: .minYEdge)
        pvc.view.frame = f
        pvc.view.autoresizingMask = [.flexibleHeight]

        pvc.didMove(toParentViewController: self)

        let page = Person(pepBoy: self.pep[0])
        pvc.setViewControllers([page], direction: .forward, animated: false)

        self.pageViewController = pvc

    }



    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
        let boy = (vc as! Person).boy
        let ix = self.pep.index(of:boy)! + 1
        if ix >= self.pep.count {
            return nil
        }
        return Person(pepBoy: self.pep[ix])
    }
    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
        let boy = (vc as! Person).boy
        let ix = self.pep.index(of:boy)! - 1
        if ix < 0 {
            return nil
        }
        return Person(pepBoy: self.pep[ix])
    }

    // if these methods are implemented, page indicator appears

    func presentationCount(for pvc: UIPageViewController) -> Int {
        return self.pep.count
    }
    func presentationIndex(for pvc: UIPageViewController) -> Int {
        let page = pvc.viewControllers![0] as! Person
        let boy = page.boy
        return self.pep.index(of:boy)!
    }
    
    
}

