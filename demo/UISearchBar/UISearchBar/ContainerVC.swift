
import UIKit


// TODO: 怎么设置
@available(iOS 9.1, *)
class MySearchContainerViewController : UISearchContainerViewController {
    override func viewDidLayoutSubviews() {
        self.searchController.searchBar.frame = CGRect(x: 0, y: 40, width: 300, height: 100)
    }
}


class MyContainerViewController : UIViewController {

    let searchController : UISearchController

    init(searchController: UISearchController) {
        self.searchController = searchController
        super.init(nibName:nil, bundle:nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// FIXME: navigationBar 透明, searchBar 位置不对
class MyParentViewController : UIViewController {

    var didSetup = false
    let searcher : UISearchController

    init(searcher: UISearchController) {
        self.searcher = searcher
        super.init(nibName:nil, bundle:nil)
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !didSetup {
            didSetup = true
            let scvc = MyContainerViewController(searchController: self.searcher)
            self.addChildViewController(scvc)
            scvc.view.frame = self.view.bounds
            scvc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(scvc.view)
            let b = searcher.searchBar
            b.sizeToFit()
            b.autoresizingMask = [.flexibleWidth]
            b.autocapitalizationType = .none
            scvc.view.addSubview(b)

            //scvc.didMove(toParentViewController: self)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        searcher.dismiss(animated: false, completion: nil)
    }

    deinit {
        print("bye")
    }

}


class ContainerVC : AppTableVC, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let b = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(doSearch))
        self.navigationItem.rightBarButtonItem = b
    }

    @objc func doSearch(_ sender: Any) {

        let src = SearchResultsController(data: self.sectionData)
        let searcher = AppSearchController(searchResultsController: src)
        searcher.searchResultsUpdater = src
        searcher.hidesNavigationBarDuringPresentation = false
        if #available(iOS 9.1, *) {
            searcher.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
            searcher.dimsBackgroundDuringPresentation = false
        }
        searcher.searchBar.delegate = self

        // construct container view controller
        let vc = MyParentViewController(searcher: searcher)

        self.navigationController!.pushViewController(vc, animated:true)
        // self.present(vc, animated:true)
    }

}
