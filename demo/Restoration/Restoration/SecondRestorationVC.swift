

import UIKit

class SecondRestorationVC : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(type(of:self)) will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(type(of:self)) did appear")
    }

    override func encodeRestorableState(with coder: NSCoder) {
        print("\(type(of:self)) encode \(coder)")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("\(type(of:self)) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        print("finished \(type(of:self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load \(type(of:self))")
        self.view.backgroundColor = .yellow

        let b = UIBarButtonItem(title:"RestoreArbitraryObject",
                                style:.plain, target:self, action:#selector(showNext))
        self.navigationItem.rightBarButtonItem = b

        let button = UIButton(type:.system)
        button.setTitle("Present", for:.normal)
        button.addTarget(self,
            action:#selector(doPresent),
            for:.touchUpInside)
        button.sizeToFit()
        button.center = self.view.center
        self.view.addSubview(button)
    }
    
    class func makePresentedViewController () -> UIViewController {
        let pvc = PresentedRestorationVC()
        pvc.restorationIdentifier = "presented"
        pvc.restorationClass = self
        return pvc
    }
    
    func doPresent(_ sender: Any?) {
        let pvc = type(of:self).makePresentedViewController()
        self.present(pvc, animated:true)
    }

    func showNext() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SaveAndRestoreArbitraryObjectVC")
        show(vc, sender: nil)
    }
}

// Aclassic mistake is to implement viewControllerWithRestorationIdentifierPath, but forget to declare explicit conformance to UIViewControllerRestoration. In that case, restoration will fail, without a crash, but now (new in iOS 8?) with a delightfully helpful message: "Warning: restoration class for view controller does not conform to UIViewControllerRestoration protocol: Class is ..."

extension SecondRestorationVC : UIViewControllerRestoration {
    class func viewController(withRestorationIdentifierPath ip: [Any],
        coder: NSCoder) -> UIViewController? {
            print("vcwithrip \(NSStringFromClass(self)) \(ip) \(coder)")
            var vc : UIViewController? = nil
            let last = ip.last as! String
            switch last {
            case "presented":
                vc = self.makePresentedViewController()
            default: break
            }
            return vc
    }
}

