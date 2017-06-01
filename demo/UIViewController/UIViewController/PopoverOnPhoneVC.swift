
import UIKit

fileprivate class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wv = UIWebView()
        wv.backgroundColor = .white
        self.view.addSubview(wv)
        wv.frame = self.view.bounds
        wv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let f = Bundle.main.path(forResource: "linkhelp", ofType: "html")
        let s = try! String(contentsOfFile: f!)
        wv.loadHTMLString(s, baseURL: nil)
    }
}


class PopoverOnPhoneVC: UIViewController {
                            
    @IBAction func doButton(_ sender: Any) {
        let vc = MyViewController()
        vc.preferredContentSize = CGSize(400,500)
        vc.modalPresentationStyle = .popover
        
        // declare the delegate _before_ presentation!
        if let pres = vc.presentationController {
            pres.delegate = self // comment out to see what the defaults are
        }

        self.present(vc, animated: true)
        
        if let pop = vc.popoverPresentationController {
            print(pop)
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
            pop.backgroundColor = .white
        }
        
        // that alone is completely sufficient, on iOS 8, for iPad and iPhone!
        // on iPhone the v.c. will be modal fullscreen by default
        // thus there is no need for conditional code about what device this is!
        
        // however, there's no way to dismiss the fullscreen web view on iPhone
        // the way we take care of this is thru the popover presentation controller's delegate
        // it substitutes a different view controller with a Done button
    }
}

extension PopoverOnPhoneVC : UIPopoverPresentationControllerDelegate {
    
    // UIPopoverPresentationControllerDelegate conforms to UIAdaptivePresentationControllerDelegate
    
    // no need to call this any longer, though you can if you want to
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.horizontalSizeClass == .compact {
            // return .none // permitted not to adapt even on iPhone
            // return .formSheet // can also cover partially on iPhone
            return .fullScreen
        }
        // return .fullScreen // permitted to adapt even on iPad
        // return .formSheet // can adapt to anything
        return .none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        // we actually get the chance to swap out the v.c. for another!
        if style != .popover {
            let vc = controller.presentedViewController
            let nav = UINavigationController(rootViewController: vc)
            let b = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissHelp))
            vc.navigationItem.rightBarButtonItem = b
            return nav
        }
        return nil
    }
    
    @IBAction func dismissHelp(_ sender: Any) {
        self.dismiss(animated:true)
    }

}

