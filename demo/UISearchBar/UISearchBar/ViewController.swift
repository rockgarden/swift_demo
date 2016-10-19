

import UIKit

func imageFromContextOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

func lend<T> (_ closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController {
    
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
        
        let sepim = imageFromContextOfSize(CGSize(width: 320,height: 20)) {
            UIBezierPath(roundedRect:CGRect(x: 5,y: 0,width: 320-5*2,height: 20), cornerRadius:8).addClip()
            UIImage(named:"sepia.jpg")!.draw(in: CGRect(x: 0,y: 0,width: 320,height: 20))
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
        let mannyim = imageFromContextOfSize(CGSize(width: 20,height: 20)) {
            manny.draw(in: CGRect(x: 0,y: 0,width: 20,height: 20))
        }
        self.sb.setImage(mannyim, for:.clear, state:UIControlState())
        
        let moe = UIImage(named:"moe.jpg")!
        let moeim = imageFromContextOfSize(CGSize(width: 20,height: 20)) {
            moe.draw(in: CGRect(x: 0,y: 0,width: 20,height: 20))
        }
        self.sb.setImage(moeim, for:.clear, state:.highlighted)
        
        self.sb.showsScopeBar = true
        self.sb.scopeButtonTitles = ["Manny", "Moe", "Jack"]
        
        self.sb.scopeBarBackgroundImage = UIImage(named:"sepia.jpg")
        
        self.sb.setScopeBarButtonBackgroundImage(linim, for:UIControlState())
        
        let divim = imageFromContextOfSize(CGSize(width: 2,height: 2)) {
            UIColor.white.setFill()
            UIBezierPath(rect:CGRect(x: 0,y: 0,width: 2,height: 2)).fill()
        }
        self.sb.setScopeBarButtonDividerImage(divim,
                                              forLeftSegmentState:UIControlState(), rightSegmentState:UIControlState())
        
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

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
