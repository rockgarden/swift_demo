
import UIKit

class UISearchControllerDelegateVC : AppTableVC, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let src = SearchResultsControllerTake()
        let searcher = AppSearchController(searchResultsController: src)
        self.searcher = searcher
        searcher.delegate = self
        searcher.searchResultsUpdater = src

        let b = searcher.searchBar
        /// won't show in the, shows during search only table
        b.scopeButtonTitles = ["Starts", "Contains"]
        addSearchBar(b)
    }

}

extension UISearchControllerDelegateVC : UISearchControllerDelegate {

    func willPresentSearchController(_ sc: UISearchController) {
        if let src = sc.searchResultsController as? SearchResultsControllerTake {
            src.take(data:self.sectionData)
        }
    }
    
    /*
     func presentSearchController(_ sc: UISearchController) {
     self.present(sc, animated: true)
     }
     */
}

