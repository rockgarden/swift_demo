
import UIKit


/// TODO: 演示什么??
class TestingMultitaskingVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("%@", #function)
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        NSLog("%@", #function)
        if self.presentingViewController != nil {
            self.view.backgroundColor = .yellow
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("%@", #function)
    }
    
    @IBAction func doButton(_ sender: Any) {
        if self.presentingViewController != nil {
            self.dismiss(animated:true)
        } else {
            print("window frame is \(self.view.window!.frame)")
            print("window bounds are \(self.view.window!.bounds)")
            print("screen bounds are \(UIScreen.main.bounds)")
            let v = sender as! UIView

            /// convert 将矩形从指定的坐标空间转换为当前对象的坐标空间。
            let r = self.view.window?.convert(v.bounds, from: v)
            print("button in window is \(String(describing: r))")

            /// coordinateSpace 屏幕的当前坐标空间。屏幕的当前坐标空间总是反映应用于设备的任何接口方向。因此，该坐标空间的边界与屏幕本身的边界属性相匹配。
            let r2 = v.convert(v.bounds, to: UIScreen.main.coordinateSpace)
            print("button in screen is \(r2)")
        }
    }
    
    let which = 2
    
    @IBAction func doButton2(_ sender: Any) {
        if self.presentingViewController != nil {
            return
        }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC") {
            switch which {
            case 1:
                vc.modalPresentationStyle = .formSheet
            case 2:
                vc.modalPresentationStyle = .popover
                if let pop = vc.popoverPresentationController {
                    let v = sender as! UIView
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            default: break
            }
            vc.presentationController!.delegate = self
            self.present(vc, animated:true)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let larger = max(size.width, size.height)
        let smaller = min(size.width, size.height)
        print(#function, size, larger/smaller, terminator:"\n\n")
        super.viewWillTransition(to: size, with: coordinator)
        delay(1) {
            let ok = self.traitCollection.horizontalSizeClass == .compact
            print("compact?", ok, terminator:"\n\n")
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print(#function, newCollection, terminator:"\n\n")
        super.willTransition(to: newCollection, with: coordinator)
        delay(1) {
            let ok = self.traitCollection.horizontalSizeClass == .compact
            print("compact?", ok, terminator:"\n\n")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print(#function, self.traitCollection, terminator:"\n\n")
        super.traitCollectionDidChange(previousTraitCollection)
    }

}


extension TestingMultitaskingVC : UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("adapt!")
        if traitCollection.horizontalSizeClass == .compact {
            return .fullScreen
        }
        return .none
    }

}

