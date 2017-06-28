

import UIKit

class OrientationsPermittedVC : UIViewController {
    
    /// 如何覆盖应用程序的可能方向列表 在视图控制器级别
    /// how to override the application's list of possible orientations at the view controller level
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        print(UIApplication.shared.statusBarOrientation.rawValue)
        print(UIDevice.current.orientation.rawValue)
        let result = UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        print(result)
        print("supported") // called 7 times at launch! WTF?

        /// VC支持的方向必须是应用程序支持方向的子集，否则 crash 'Supported orientations has no common orientation with the application'
        /**  
         func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { return .landscape }
         */
        
        // wait! now, .all means .all!
        return .all
        //return .portrait
    }

    // we are called *every time* the device rotates (twice, it seems)

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //print("transition to size", size)
        NSLog("transition to size %@", NSStringFromCGSize(size))
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // print("transition to tc", newCollection)
        NSLog("transition to tc %@ from %@", newCollection, self.traitCollection)
    }

    override func viewDidLoad() {
        let l = UILabel(frame: CGRect(60,60,100,20))
        l.text = "Test orientation permitted"
        view.backgroundColor = .white
        view.addSubview(l)
    }

}

