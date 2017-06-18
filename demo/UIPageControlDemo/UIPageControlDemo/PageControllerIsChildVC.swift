
import UIKit

class PageControllerIsChildVC: AppUIPageVC {

    weak var pageViewController : UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.6)
        proxy.currentPageIndicatorTintColor = .red
        proxy.backgroundColor = .yellow

        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pvc.dataSource = self
        addChildViewController(pvc)
        view.addSubview(pvc.view)

        let (_,f) = self.view.bounds.divided(atDistance: 50, from: .minYEdge)
        pvc.view.frame = f
        pvc.view.autoresizingMask = [.flexibleHeight]

        pvc.didMove(toParentViewController: self)

        let page = Person(pepBoy: pep[0])
        pvc.setViewControllers([page], direction: .forward, animated: false)

        self.pageViewController = pvc
    }

}

