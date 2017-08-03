
import UIKit

class AssistiveLayoutVC: UIViewController {

    lazy var greenView : UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()

    var firstTime = true
    var nextTraitCollection = UITraitCollection()

    func greenViewShouldAppear(size sz: CGSize) -> Bool {
        let tc = self.nextTraitCollection
        debugPrint(tc.horizontalSizeClass)
        /// trait集合的水平大小类。未指定trait集合的默认横向大小类。plus 和 ipad 的 horizontalSizeClass 才为 regular
        if tc.horizontalSizeClass == .regular {
            if sz.width > sz.height {
                return true
            }
        }
        return false
    }

    /// 1(rotate). 告诉每个相关的视图控制器它的traits即将改变。
    /// if tc is going to change, we _know_ we will hear about it before we hear about size change
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to:newCollection, with:coordinator)
        self.nextTraitCollection = newCollection
    }

    /// 2(rotate). 告诉每个相关的视图控制器它的大小将要改变。
    /// we _know_ we will get this on rotation and splitscreen changes even on iPad
    override func viewWillTransition(to sz: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:sz, with:coordinator)
        print (self.nextTraitCollection)
        print (self.traitCollection)
        if sz != self.view.bounds.size {
            // there are three theoretical possibilities:
            // view is present and needs to disappear
            // view is absent and needs to appear
            // view is present and needs to be resized
            // but the third possibility never actually happens
            if self.greenView.window != nil {
                if !self.greenViewShouldAppear(size:sz) {
                    coordinator.animate(alongsideTransition: { _ in
                        let f = self.greenView.frame
                        self.greenView.frame = CGRect(-f.width,0,f.width,f.height)
                    }) { _ in
                        self.greenView.removeFromSuperview()
                    }
                } else {
                    coordinator.animate(alongsideTransition: { _ in
                        self.greenView.frame = CGRect(-sz.width/3,0,sz.width/3,sz.height)
                        fatalError("I'm betting this can never happen")
                    })
                }
            } else {
                if self.greenViewShouldAppear(size:sz) {
                    self.greenView.frame = CGRect(-sz.width/3,0,sz.width/3,sz.height)
                    self.view.addSubview(self.greenView)
                    coordinator.animate(alongsideTransition: { _ in
                        self.greenView.frame.origin = CGPoint.zero
                    })
                }
            }
        }
    }

    /// 3(rotate). 告诉每个相关的视图控制器它的traits现在已经改变。
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("trait collection did change to \(self.traitCollection)")
    }

    /// 4. 开始调整
    /// we _know_ we will get this at launch with our view ready to go
    override func viewWillLayoutSubviews() {
        if self.firstTime {
            self.firstTime = false
            self.nextTraitCollection = self.traitCollection
            let sz = self.view.bounds.size
            if self.greenViewShouldAppear(size:sz) {
                let v = self.greenView
                v.frame = CGRect(0,0,sz.width/3, sz.height)
                view.addSubview(v)
            }
        }
    }

    @IBAction func doDismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

