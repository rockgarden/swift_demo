
import UIKit

class UISearchBarVC: UIViewController {
    
    @IBOutlet var sb : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sb.enablesReturnKeyAutomatically = false // true by default, even though unchecked!
        self.sb.searchBarStyle = .default
        self.sb.barStyle = .default
        self.sb.isTranslucent = true
        self.sb.barTintColor = UIColor.green // unseen in this example
        // self.sb.backgroundColor = UIColor.redColor()
        
        let lin = UIImage(named:"linen.png")!
        let linim = lin.resizableImage(withCapInsets: UIEdgeInsetsMake(1,1,1,1), resizingMode:.stretch)
        self.sb.setBackgroundImage(linim, for:.any, barMetrics:.default)
        self.sb.setBackgroundImage(linim, for:.any, barMetrics:.defaultPrompt)
        
        let sepim = imageOfSize(CGSize(320,20)) {
            UIBezierPath(roundedRect:CGRect(5,0,320-5*2,20), cornerRadius:8).addClip()
            UIImage(named:"sepia.jpg")!.draw(in:CGRect(0,0,320,20))
        }
        self.sb.setSearchFieldBackgroundImage(sepim, for:UIControlState())
        // just to show what it does:
        self.sb.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, -10) // up from center
        
        // how to reach in and grab the text field
        for v in self.sb.subviews[0].subviews {
            if let tf = v as? UITextField {
                print("got that puppy")
                tf.textColor = UIColor.white
                // tf.enabled = false
                break
            }
        }
        
        self.sb.text = "Search me!"
        //self.sb.placeholder = "Search me!"
        //    self.sb.showsBookmarkButton = true
        //    self.sb.showsSearchResultsButton = true
        //    self.sb.searchResultsButtonSelected = true
        
        let manny = UIImage(named:"manny.jpg")!
        self.sb.setImage(manny, for:.search, state:UIControlState())
        let mannyim = imageOfSize(CGSize(20,20)) {
            manny.draw(in:CGRect(0,0,20,20))
        }
        self.sb.setImage(mannyim, for:.clear, state:UIControlState())
        
        let moe = UIImage(named:"moe.jpg")!
        let moeim = imageOfSize(CGSize(20,20)) {
            moe.draw(in:CGRect(0,0,20,20))
        }
        self.sb.setImage(moeim, for:.clear, state:.highlighted)
        
        self.sb.showsScopeBar = true
        self.sb.scopeButtonTitles = ["Manny", "Moe", "Jack"]
        
        self.sb.scopeBarBackgroundImage = UIImage(named:"sepia.jpg")
        
        self.sb.setScopeBarButtonBackgroundImage(linim, for:UIControlState())
        
        let divim = imageOfSize(CGSize(2,2)) {
            UIColor.white.setFill()
            UIBezierPath(rect:CGRect(0,0,2,2)).fill()
        }
        self.sb.setScopeBarButtonDividerImage(divim,
                                              forLeftSegmentState:.normal, rightSegmentState:.normal)
        
        let atts = [
            NSFontAttributeName: UIFont(name:"GillSans-Bold", size:16)!,
            NSForegroundColorAttributeName: UIColor.white,
            NSShadowAttributeName: lend {
                (shad:NSShadow) in
                shad.shadowColor = UIColor.gray
                shad.shadowOffset = CGSize(width: 2,height: 2)
            },
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleDouble.rawValue
        ] as [String : Any]
        self.sb.setScopeBarButtonTitleTextAttributes(atts, for:UIControlState())
        self.sb.setScopeBarButtonTitleTextAttributes(atts, for:.selected)
        
    }
}

extension UISearchBarVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
