
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
        if let pC = vc.presentationController {
            pC.delegate = self
            /// 实现UIAdaptivePresentationControllerDelegate协议。
        }

        self.present(vc, animated: true)
        
        if let pop = vc.popoverPresentationController {
            print(pop)
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
            pop.backgroundColor = .white
        }
        /// iPhone上的vc默认情况下将全屏模式, ？而且没有办法在iPhone上关闭全屏网页视图
    }
}


/// UIPopoverPresentationControllerDelegate conforms to UIAdaptivePresentationControllerDelegate
extension PopoverOnPhoneVC : UIPopoverPresentationControllerDelegate {
    
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
        // TODO: 自定义VC
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

