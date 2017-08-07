

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
        
        return .all
        //return .portrait
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        NSLog("transition to size %@", NSStringFromCGSize(size))
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        NSLog("transition to tc %@ from %@", newCollection, self.traitCollection)
    }

    override func viewDidLoad() {
        let l = UILabel(frame: CGRect(60,60,210,20))
        l.text = "Test orientation permitted"
        view.backgroundColor = .white
        view.addSubview(l)
        l.autoresizingMask = .flexibleWidth
        
        let b = UIButton(type: .roundedRect)
        b.frame = CGRect(60,160,210,20)
        b.setTitle("View orientation permitted", for: .normal)
        b.addTarget(nil, action: #selector(OrientationsPermittedVC.jumpNext), for: .touchUpInside)
        view.addSubview(b)
        b.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]

        let cB = UIButton(type: .roundedRect)
        cB.frame = CGRect(60,260,100,20)
        cB.setTitle("Close", for: .normal)
        cB.addTarget(nil, action: #selector(OrientationsPermittedVC.close), for: .touchUpInside)
        view.addSubview(cB)
        cB.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
    }

    func jumpNext() {
        let sb = UIStoryboard(name: "OrientationsPermitted", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AttemptRotationVC")
        show(vc, sender: nil)
    }

    func close() {
        dismiss(animated: true, completion: nil)
    }

}

