import UIKit

class PopoverVC : AppTableVC, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let src = SearchResultsController(data: self.sectionData)
        let searcher = UISearchController(searchResultsController: src)
        self.searcher = searcher
        searcher.hidesNavigationBarDuringPresentation = false

        // make it a popover!
        /// 一个布尔值，指示视图控制器或其后代呈现视图控制器时是否覆盖此视图控制器的视图。当使用currentContext或overCurrentContext样式来呈现视图控制器时，此属性控制视图控制器层次结构中现有的视图控制器实际上被新内容覆盖。 当基于上下文的演示文稿发生时，UIKit将在显示视图控制器处启动，并向上移动视图控制器层次结构。 如果它找到一个视图控制器，该属性的值为true，它会要求视图控制器显示新的视图控制器。 如果没有视图控制器定义演示文稿上下文，UIKit会询问窗口的根视图控制器来处理演示文稿。此属性的默认值为false。 一些系统提供的视图控制器（如UINavigationController）将默认值更改为true。
        definesPresentationContext = true
        searcher.modalPresentationStyle = .popover
        searcher.preferredContentSize = CGSize(400,400)

        searcher.searchResultsUpdater = src

        let b = searcher.searchBar
        // b.sizeToFit()
        // b.frame.size.width = 250
        b.autocapitalizationType = .none
        self.navigationItem.titleView = b
        b.showsCancelButton = true // no effect

        // however, I'm having difficulty detecting dismissal of the popover
        searcher.delegate = self
        if let pres = searcher.presentationController {
            print("setting presentation controller delegate")
            pres.delegate = self
        }

        //(searcher.presentationController as! UIPopoverPresentationController).delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        searcher.dismiss(animated: false, completion: nil)
    }

}


extension PopoverVC : UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) { print(#function) }
    func willPresentSearchController(_ searchController: UISearchController) { print(#function) }
    func didPresentSearchController(_ searchController: UISearchController) { print(#function) }
    // these next functions are not called, I regard this as a bug
    func willDismissSearchController(_ searchController: UISearchController) { print(#function) }
    func didDismissSearchController(_ searchController: UISearchController) { print(#function) }
}


extension PopoverVC : UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ pop: UIPopoverPresentationController) {
        print("prepare")
        //        print(pop.sourceView)
        //        print(pop.passthroughViews)
        //        print(pop.delegate)
    }
    func popoverPresentationControllerShouldDismissPopover(_ pop: UIPopoverPresentationController) -> Bool {
        print("pop should dismiss")
        self.searcher.searchBar.text = nil
        return true
    }
    func popoverPresentationControllerDidDismissPopover(_ pop: UIPopoverPresentationController) {
        print("pop dismiss")
        self.searcher.presentationController?.delegate = self
    }
}


extension PopoverVC : UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("waha")
        return .none
    }
}


