//
//  UIPageDemo.swift
//  UIPageControlDemo
//
//  Created by wangkan on 2017/2/24.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

let pep : [String] = ["Manny", "Moe", "Jack"]

class RootVC_PageControl: UITableViewController {

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 1:
                // make a page view controller - NB try both .pageCurl and .scroll
                let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                // give it an initial page
                let page = Person(pepBoy: pep[0])
                pvc.setViewControllers([page], direction: .forward, animated: false)
                // give it a data source
                pvc.dataSource = self
                // put its view into the interface
                self.show(pvc, sender: nil)
                // FIXME: 高度不对,没有低于navbar
            case 4:
                let pvc = TabPageVC()
                self.show(pvc, sender: nil)
            case 5:
                let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                let vc = SwipeVC(rootViewController: pageController)
                self.show(vc, sender: nil)
            default:
                break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
    }
    
}


extension RootVC_PageControl: UIPageViewControllerDataSource {

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

    // if these methods are implemented, page indicator appears
    func presentationCount(for pvc: UIPageViewController) -> Int {
        return pep.count
    }

    func presentationIndex(for pvc: UIPageViewController) -> Int {
        let page = pvc.viewControllers![0] as! Person
        let boy = page.boy
        return pep.index(of: boy)!
    }

    // =======
    func messWithGestureRecognizers(_ pvc: UIPageViewController) {
        if pvc.transitionStyle == .pageCurl { // does nothing for .scroll
            for g in pvc.gestureRecognizers {
                if let g = g as? UITapGestureRecognizer {
                    g.numberOfTapsRequired = 2
                }
            }
        }
        else { // not needed for .PageCurl
            NotificationCenter.default.addObserver(forName:.tap, object: nil, queue: .main) { n in
                let g = n.object as! UIGestureRecognizer
                let which = g.view!.tag
                let vc0 = pvc.viewControllers![0]
                guard let vc = (which == 0 ? self.pageViewController(pvc, viewControllerBefore: vc0) : self.pageViewController(pvc, viewControllerAfter: vc0))
                    else {return}
                let dir : UIPageViewControllerNavigationDirection = which == 0 ? .reverse : .forward
                UIApplication.shared.beginIgnoringInteractionEvents()
                pvc.setViewControllers([vc], direction: dir, animated: true) {
                    _ in
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
}


internal extension Notification.Name {
    static let tap = Notification.Name("tap")
}

