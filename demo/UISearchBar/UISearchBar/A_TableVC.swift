

import UIKit


// Dynamic Table Content
// StroyBoard中copy控件TableView的Delegate要重新配置
class A_TableVC : AppTableVC, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let src = A_SearchResultsC() // we will configure later
        let searcher = AppSearchController(searchResultsController: src)
        self.searcher = searcher
        searcher.delegate = self // so we can configure results controller and presentation
        
        let b = searcher.searchBar
        b.scopeButtonTitles = ["Starts", "Contains"] // won't show in the table
        addSearchBar(b)
    }

}

extension A_TableVC : UISearchControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var which : Int {return 1}
    func presentSearchController(_ sc: UISearchController) {
        print("search!")
        // good opportunity to control timing of search results controller configuration
        let src = sc.searchResultsController as! A_SearchResultsC
        src.takeData(self.sectionData) // that way if it changes we are up to date
        sc.searchResultsUpdater = src
        sc.searchBar.delegate = src
        
        switch which {
        case 0: break
        case 1:
            sc.transitioningDelegate = self
            sc.modalPresentationStyle = .custom // ?
        default: break
        }
        self.present(sc, animated: true, completion: nil)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let p = UIPresentationController(presentedViewController: presented, presenting: presenting)
        print("wow") // never called, sorry
        return p
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let vc1 = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let vc2 = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let con = transitionContext.containerView
        
        // let r1start = transitionContext.initialFrameForViewController(vc1)
        let r2end = transitionContext.finalFrame(for: vc2)
        
        // let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let v2 = transitionContext.view(forKey: UITransitionContextViewKey.to)

        if let v2 = v2 { // presenting, vc2 is the search controller
            
            // our responsibilities are:
            // get vc2 into the interface, obviously
            // get **the search bar** into the presented interface!
            // and we can animate that
            // (plus we are responsible for the Cancel button)
            
            con.addSubview(v2)
            v2.frame = r2end
            let sc = vc2 as! UISearchController
            let sb = sc.searchBar
            sb.removeFromSuperview()
            // hold my beer and watch _this_!
            sb.showsScopeBar = true
            sb.sizeToFit()
            v2.addSubview(sb)
            sb.frame.origin.y = -sb.frame.height
            UIView.animate(withDuration: 0.3, animations: {
                sb.frame.origin.y = 0
                }, completion: {
                    _ in
                    sb.setShowsCancelButton(true, animated: true)
                    transitionContext.completeTransition(true)
                })
        } else { // dismissing, vc1 is the search controller
            
            // we have no major responsibilities...
            // but if we showed the cancel button and we don't want it in the normal interface,
            // we need to get rid of it now; similarly with the scope bar
            
            let sc = vc1 as! UISearchController
            let sb = sc.searchBar
            sb.showsCancelButton = false
            sb.showsScopeBar = false
            sb.sizeToFit()

            UIView.animate(withDuration: 0.3, animations: {
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
                })
        }
        
    }

}
