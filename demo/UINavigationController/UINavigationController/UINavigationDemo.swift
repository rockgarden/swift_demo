

import UIKit

class UINavigationDemo : UIViewController, UINavigationControllerDelegate {

    var queryButton: UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "files.png"), for: UIControlState())
        button.setBackgroundImage(UIImage(named: "key.png"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.imageRect(forContentRect: CGRect(x: 2, y: 2, width: 30, height: 30))
        button.imageEdgeInsets = UIEdgeInsetsMake(-4, 32, -4, 32) //move image to the right
        button.showsTouchWhenHighlighted = true
        button.addTarget(nil, action: #selector(navigate), for: .touchUpInside)
        let gr = UITapGestureRecognizer(target: self, action: #selector(navigate))
        button.addGestureRecognizer(gr)

        let label = UILabel(frame: CGRect(3, 5, 100, 20))
        label.font = UIFont(name: "Arial-BoldMT", size: 16)
        label.text = "title"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor =  .clear
        button.addSubview(label)

        return button
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.title = "NavigationItem"
        let b1 = UIBarButtonItem(image:UIImage(named:"key.png"), style:.plain, target:self, action:#selector(navigate))
        let b2 = UIBarButtonItem(image:UIImage(named:"files.png"),
                                 style:.plain, target:nil, action:nil)
        self.navigationItem.rightBarButtonItems = [b1, b2]

        let barButton = UIBarButtonItem(customView: queryButton)
        self.navigationItem.leftBarButtonItem = barButton

        //self.navigationItem.setRightBarButton(barButton, animated: true)

        /*
         // if right bar button item set up in storyboard so we can use a "show" segue
         let b2 = UIBarButtonItem(image:UIImage(named:"files.png"), style:.Plain, target:nil, action:nil)
         // how to append additional right bar button items
         var rbbi = self.navigationItem.rightBarButtonItems!
         rbbi += [b2]
         self.navigationItem.rightBarButtonItems = rbbi
         */

        // how to customize back button
        let b3 = UIBarButtonItem(image:UIImage(named:"files.png"), style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = b3

    }

    func navigate() {
        let vc = SecondeVC(nibName: nil, bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.show(vc, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 若采用 TFNavigationController 则不可实现 UINavigationControllerDelegate
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
    //        return .lightContent
    //    }

    //    override func prefersStatusBarHidden() -> Bool {
    //        return true
    //    }
    
}


