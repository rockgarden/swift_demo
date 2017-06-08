
import UIKit

class SecondeVC : UIViewController {
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Second"
        let b = UIBarButtonItem(image: UIImage(named:"files.png"), style: .plain, target: nil, action: nil)

        // can have both left bar buttons and back bar button
        self.navigationItem.leftBarButtonItem = b
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
    // with a back button, we get "pop" for free, both by tapping the button...
    // and interactively by dragging from the left edge
    
    // this looks like a bug: we are not getting light content
    
    //    override func preferredStatusBarStyle() -> UIStatusBarStyle {
    //        return .LightContent
    //    }
    
    //    override func prefersStatusBarHidden() -> Bool {
    //        return false
    //    }
    
}


//FIXME: TFTransparentNavigationBarProtocol 实现异常
extension SecondeVC: TFTransparentNavigationBarProtocol {
   
    func navigationControllerBarPushStyle() -> TFNavigationBarStyle {
        return .transparent
    }
}
