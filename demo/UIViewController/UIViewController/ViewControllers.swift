
import UIKit

class FirstViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(view)
        print(nibName as Any)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(self.view.bounds.size)
        print(self.navigationController!.view.bounds.size)
    }

    private var hide = false

    override var prefersStatusBarHidden : Bool {
        return self.hide
    }

    @IBAction func underlapButton(_ sender: Any) {
        self.hide = !self.hide
        UIView.animate(withDuration:0.4) {
            /// Ask the system to re-query our -preferredStatusBarStyle.
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }
    }
    
}

class SecondViewController : UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
        
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
    }

    var which = 1
    @IBAction func doPresent(_ sender: Any?) {

        let vc = ExtraViewController(nibName: "ExtraViewController", bundle: nil)
        vc.which = which
        switch which {
        case 1:
            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true)
        case 2:
            /// in iOS 8/9, this works on iPhone as well as iPad!, 显示vc出现在第一个vc *里面的* tabbed界面中 presented vc appears over first vc *inside* tabbed interface
            vc.modalTransitionStyle = .flipHorizontal
            self.definesPresentationContext = true
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true)

        case 3:
            vc.modalTransitionStyle = .flipHorizontal
            self.definesPresentationContext = true
            /// 一个布尔值，指示视图控制器是否指定其呈现的视图控制器的转换样式。当视图控制器的definePresentationContext属性为true时，它可以用自己的视图控制器替换所呈现的视图控制器的转换样式。 当此属性的值为true时，将使用当前视图控制器的转换样式，而不是与呈现的视图控制器相关联的样式。 当此属性的值为false时，UIKit将使用所呈现的视图控制器的转换样式。 此属性的默认值为false。
            self.providesPresentationContextTransitionStyle = true
            self.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .currentContext

            vc.modalPresentationCapturesStatusBarAppearance = true

            self.present(vc, animated: true)
        default: break
        }
        which = which < 3 ? which+1 : 1
    }

    override func viewDidLoad() {
        self.tabBarController?.delegate = self
    }

    @IBAction func showOrientations(_ sender: Any) {
        let vc = OrientationsPermittedVC()
        present(vc, animated: true)
    }

}


extension SecondViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return self.presentedViewController == nil
        //return true
    }
}
