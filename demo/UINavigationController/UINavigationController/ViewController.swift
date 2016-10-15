

import UIKit

class ViewController : UIViewController, UINavigationControllerDelegate {
    
    var queryButton: UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "files.png"), for: UIControlState())
        button.setBackgroundImage(UIImage(named: "key.png"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        button.imageRectForContentRect(CGRect(x: 2, y: 2, width: 30, height: 30))
        button.imageEdgeInsets = UIEdgeInsetsMake(-4, 4, -4, 4)
        button.showsTouchWhenHighlighted = true
        button.addTarget(nil, action: #selector(navigate), for: .touchUpInside)
        let gr = UILongPressGestureRecognizer(target: self, action: #selector(navigate))
        gr.minimumPressDuration = 1
        button.addGestureRecognizer(gr)
        return button
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "First"
        _ = UIBarButtonItem(image:UIImage(named:"key.png"), style:.plain, target:self, action:#selector(navigate))
        _ = UIBarButtonItem(image:UIImage(named:"files.png"),
                                 style:.plain, target:nil, action:nil)
        //self.navigationItem.rightBarButtonItems = [b1, b2]
        //        let button =  UIButton(type: .Custom)
        //        button.setBackgroundImage(UIImage(named: "key.png"), forState: .Normal)
        //        button.setBackgroundImage(UIImage(named: "key.png"), forState: .Selected)
        //        button.addTarget(self, action: #selector(navigate), forControlEvents: .TouchUpInside)
        //        button.frame = CGRectMake(0, 0, 53, 31)
        //        button.imageEdgeInsets = UIEdgeInsetsMake(-1, 32, 1, -32)//move image to the right
        //        let label = UILabel(frame: CGRectMake(3, 5, 50, 20))
        //        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        //        label.text = "title"
        //        label.textAlignment = .Center
        //        label.textColor = UIColor.whiteColor()
        //        label.backgroundColor =   UIColor.clearColor()
        //        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: queryButton)
        self.navigationItem.leftBarButtonItem = barButton
        //self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        
        // how to customize back button
        //let b3 = UIBarButtonItem(image:UIImage(named:"files.png"), style:.Plain, target:nil, action:nil)
        //self.navigationItem.backBarButtonItem = b3
        
    }
    
    func navigate() {
        let v2c = View2Controller(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(v2c, animated: true)
        // alternatively, can use new way in iOS 8:
        // self.showViewController(v2c, sender: self)
        // makes no difference here; the purpose is to loosen the coupling ...
        // ... in a possible split view controller situation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
        // uncomment to get white status bar text
        // self.navigationController!.navigationBar.barStyle = .Black
        // uncomment to hide navigation bar
        // self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    //    override func preferredStatusBarStyle() -> UIStatusBarStyle {
    //        return .LightContent
    //    }
    
    //    override func prefersStatusBarHidden() -> Bool {
    //        return true
    //    }
    
    
}
