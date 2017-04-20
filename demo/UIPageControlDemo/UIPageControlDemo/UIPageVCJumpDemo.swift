
import UIKit

class UIPageVCJumpDemo : UIViewController {

    /// Embed segue
    /// 基于Container View实现,本质上就是在一个ViewController的View嵌入另外一个ViewController,相当于childViewController.
    /// 从MVC的设计模式来看,这是一个解耦合的过程,由嵌入式的ViewController来负负责一块区域的Modol和View的协调,如果由一个ViewController来实现会造成单个ViewController过于臃肿.
    /// - Parameters:
    ///   - segue: segue description
    ///   - sender: sender description
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let pvc = segue.destination as! UIPageViewController
        pvc.dataSource = self
        let page = MyPage()
        page.num = 1
        pvc.setViewControllers([page], direction:.forward, animated:false)
    }

    // this bug appears to be fixed in iOS 8! here's what it was:
    // start at page 1
    // click the button to jump to page 8
    // now swipe backwards to see the previous page
    // it is page 1!
    // that's the bug; the page view controller has not updated its internal state
    func jumpTo8(_ sender: Any?) {
        let page = MyPage()
        page.num = 8
        let pvc = self.childViewControllers[0] as! UIPageViewController
        pvc.setViewControllers([page], direction: .forward, animated: true) {
            _ in
            // workaround:
            /*
             dispatch_async(dispatch_get_main_queue()) {
             // pvc.setViewControllers([page], direction: .Forward, animated: false)
             }
             */
        }
    }

}


//MARK: UIPageViewControllerDataSource
extension UIPageVCJumpDemo: UIPageViewControllerDataSource {

    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MyPage
        let num = page.num
        if num == 10 { return nil }
        let page2 = MyPage()
        page2.num = num+1
        return page2
    }

    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MyPage
        let num = page.num
        if num == 1 { return nil }
        let page2 = MyPage()
        page2.num = num-1
        return page2
    }
    
}
