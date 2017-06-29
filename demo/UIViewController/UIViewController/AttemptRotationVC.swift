
import UIKit


class AttemptRotationVC : UIViewController {
    @IBOutlet var lab: UILabel!
    @IBOutlet var v: UIView!
    
    var shouldRotate = false
    
    override func viewDidLoad() {
        self.adjustLabel()
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        /// 起初，设备还没有方向 at first, the device doesn't have an orientation yet
        let orientation = UIDevice.current.orientation
        print("supported, device \(orientation.rawValue)")
        
        if orientation != .unknown {
            print("status bar \(UIApplication.shared.statusBarOrientation.rawValue)")
        }
        // return super.supportedInterfaceOrientations()
        return .all // this includes upside down if info.plist includes it
    }
    
    override var shouldAutorotate : Bool {
        let orientation = UIDevice.current.orientation
        print("should, device \(orientation.rawValue)")
        
        if orientation != .unknown {
            print("status bar \(UIApplication.shared.statusBarOrientation.rawValue)")
        }
        // return true
        return self.shouldRotate
    }
    
    /// 旋转并点按按钮来测试attemptRotation和shouldAotorotate
    @IBAction func doButton(_ sender: Any?) {
        self.shouldRotate = !self.shouldRotate
        self.adjustLabel()
        delay(0.1) {
            /// 尝试将所有窗口旋转到设备的方向。
            /// 某些视图控制器可能希望使用特定于应用程序的条件来确定支持什么接口方向。 如果您的视图控制器执行此操作，当这些条件更改时，您的应用程序应该调用此类方法。 系统立即尝试旋转到新的方向。
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }

    func adjustLabel() {
        self.lab.text = shouldRotate ? "On" : "Off"
    }

    // FIXME: 不能运行?
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // call super
        super.viewWillTransition(to:size, with: coordinator)
        print("will transition size change to \(size)")
        print("with target transform \(coordinator.targetTransform)")
        print("screen bounds: \(UIScreen.main.bounds)")
        print("screen native bounds: \(UIScreen.main.nativeBounds)")
        print("screen coord space bounds: \(UIScreen.main.coordinateSpace.bounds)") // *
        print("screen fixed space bounds: \(UIScreen.main.fixedCoordinateSpace.bounds)") // *
        let r = self.view.convert(self.lab.frame, to: UIScreen.main.fixedCoordinateSpace)
        print("label's frame converted into fixed space: \(r)")
        print("window frame: \(self.view.window!.frame)")
        print("window bounds: \(self.view.window!.bounds)")
        print("window transform: \(self.view.window!.transform)")
        print("view transform: \(self.view.transform)")
        coordinator.animate(alongsideTransition:{
            _ in
            print("transitioning size change to \(size)")
            /// 箭头指向设备的物理顶部 arrow keeps pointing to physical top of device
            self.v.transform = coordinator.targetTransform.inverted().concatenating(self.v.transform)
            }, completion: {
                _ in
                // showing that in iOS 8 the screen itself changes "size"
                print("did transition size change to \(size)")
                print("screen bounds: \(UIScreen.main.bounds)")
                print("screen native bounds: \(UIScreen.main.nativeBounds)")
                // screen native bounds do not change and are expressed in scale resolution
                print("screen coord space bounds: \(UIScreen.main.coordinateSpace.bounds)")
                print("screen fixed space bounds: \(UIScreen.main.fixedCoordinateSpace.bounds)")
                // concentrate on the green label and think about these numbers:
                // the fixed coordinate space's top left is glued to the top left of the physical device
                let r = self.view.convert(self.lab.frame, to: UIScreen.main.fixedCoordinateSpace)
                print("label's frame converted into fixed space: \(r)")
                print("window frame: \(self.view.window!.frame)")
                print("window bounds: \(self.view.window!.bounds)")
                // showing that in iOS 8 rotation no longer involves application of transform to view
                print("window transform: \(self.view.window!.transform)")
                print("view transform: \(self.view.transform)")
                print(CGAffineTransform.identity)
            })
    }
    
    // layout events check
    override func viewWillLayoutSubviews() {
        print(#function)
    }
    
    override func viewDidLayoutSubviews() {
        print(#function)
    }
    
    override func updateViewConstraints() {
        print(#function)
        super.updateViewConstraints()
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
