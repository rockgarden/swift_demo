
import UIKit

class UISearchBarVC: UIViewController {

    lazy var sb: UISearchBar = {
        let v = UISearchBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(sb)
        addConstraint()

        self.sb.enablesReturnKeyAutomatically = false // true by default, even though unchecked!
        self.sb.searchBarStyle = .default
        self.sb.barStyle = .default
        self.sb.isTranslucent = true
        self.sb.barTintColor = .green // unseen in this example
        //self.sb.backgroundColor = .red

        let lin = UIImage(named: "linen")!
        let linim = lin.resizableImage(withCapInsets: UIEdgeInsetsMake(1,1,1,1), resizingMode:.stretch)
        self.sb.setBackgroundImage(linim, for:.any, barMetrics:.default)
        self.sb.setBackgroundImage(linim, for:.any, barMetrics:.defaultPrompt)
        
        let sepim = imageOfSize(CGSize(320,20)) {
            UIBezierPath(roundedRect:CGRect(5,0,320-5*2,20), cornerRadius:8).addClip()
            UIImage(named: "sepia")!.draw(in:CGRect(0,0,320,20))
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
        
        let manny = UIImage(named:"manny")!
        self.sb.setImage(manny, for:.search, state:UIControlState())
        let mannyim = imageOfSize(CGSize(20,20)) {
            manny.draw(in:CGRect(0,0,20,20))
        }
        self.sb.setImage(mannyim, for:.clear, state:UIControlState())
        
        let moe = UIImage(named:"moe")!
        let moeim = imageOfSize(CGSize(20,20)) {
            moe.draw(in:CGRect(0,0,20,20))
        }
        self.sb.setImage(moeim, for:.clear, state:.highlighted)
        
        self.sb.showsScopeBar = true
        self.sb.scopeButtonTitles = ["Manny", "Moe", "Jack"]
        
        self.sb.scopeBarBackgroundImage = UIImage(named:"sepia")
        
        self.sb.setScopeBarButtonBackgroundImage(linim, for:UIControlState())
        
        let divim = imageOfSize(CGSize(2,2)) {
            UIColor.white.setFill()
            UIBezierPath(rect:CGRect(0,0,2,2)).fill()
        }
        self.sb.setScopeBarButtonDividerImage(divim,
                                              forLeftSegmentState:.normal, rightSegmentState:.normal)
        
        let atts = [
            NSAttributedStringKey.font.rawValue: UIFont(name:"GillSans-Bold", size:16)!,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.shadow: lend {
                (shad:NSShadow) in
                shad.shadowColor = UIColor.gray
                shad.shadowOffset = CGSize(width: 2,height: 2)
            },
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleDouble.rawValue
        ] as! [String : Any]
        self.sb.setScopeBarButtonTitleTextAttributes(atts, for:UIControlState())
        self.sb.setScopeBarButtonTitleTextAttributes(atts, for:.selected)
    }

    fileprivate func addConstraint() {

        let views = ["sb": sb]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[sb]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[sb(120)]", options: [], metrics: nil, views: views),
            ].joined().map{$0})
    }

}

extension UISearchBarVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
