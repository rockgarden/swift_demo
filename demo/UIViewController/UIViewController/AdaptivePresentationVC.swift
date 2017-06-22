

import UIKit

class AdaptivePresentationVC : UIViewController, PVCSecondVCDelegate {

    var original : UIModalPresentationStyle = .pageSheet
    var adaptive : UIModalPresentationStyle = .formSheet
    /*
     UIModalPresentationFullScreen = 0,
     UIModalPresentationPageSheet NS_ENUM_AVAILABLE_IOS(3_2), // 1
     UIModalPresentationFormSheet NS_ENUM_AVAILABLE_IOS(3_2), // 2
     UIModalPresentationCurrentContext NS_ENUM_AVAILABLE_IOS(3_2), // 3
     UIModalPresentationCustom NS_ENUM_AVAILABLE_IOS(7_0), // 4
     UIModalPresentationOverFullScreen NS_ENUM_AVAILABLE_IOS(8_0), // 5
     UIModalPresentationOverCurrentContext NS_ENUM_AVAILABLE_IOS(8_0), // 6
     UIModalPresentationPopover NS_ENUM_AVAILABLE_IOS(8_0), // 7
     UIModalPresentationNone NS_ENUM_AVAILABLE_IOS(7_0) = -1,
     */
    lazy var pairs : [(Int, Int)] = {
        // hmm, I would also like to know what happens about -1
        let arr1 = [0, 1, 2, 3, 5, 6, 7] // I'll test popovers some other time
        let arr2 = [0, 1, 2, 3, 5, 6, 7, -1]
        var result = [(Int, Int)]()
        for i in arr1 {
            for j in arr2 {
                result.append(i,j)
            }
        }
        return result
    }()
    var ix = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.definesPresentationContext = true
    }

    @IBAction func doAdvance(_ sender: Any) {
        let pair = self.pairs[self.ix]
        original = UIModalPresentationStyle(rawValue:pair.0)!
        adaptive = UIModalPresentationStyle(rawValue:pair.1)!
        ix += 1
    }

    @IBAction func doPresent(_ sender: Any?) {
        print(original.rawValue, terminator: "")
        print("\t", terminator: "")
        print(adaptive.rawValue, terminator: "")
        print("\t", terminator: "")

        let svc = PVCSecondVC(nibName: "PVCSecondVC", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self

        svc.modalPresentationStyle = original

        /*
         UIPresentationController对象提供了提供的视图控制器的高级视图和过渡管理。从视图控制器呈现到被忽略的时候，UIKit使用演示控制器来管理该视图控制器的演示过程的各个方面。演示控制器可以在动画对象提供的动画之上添加自己的动画，它可以响应大小变化，并且可以管理视图控制器在屏幕上呈现的其他方面。
         当您使用当前（_：animated：completion :)方法呈现视图控制器时，UIKit将始终管理演示过程。该过程的一部分涉及创建适合于给定演示风格的演示控制器。对于内置样式（如pageSheet样式），UIKit定义并创建所需的演示控制器对象。您的应用程序可以提供自定义演示控制器的唯一时间是设置视图控制器自定义的modalPresentationStyle属性。当您要在正在呈现的视图控制器的下方添加阴影视图或装饰视图时，或者想要以其他方式修改演示文稿行为时，可能会提供自定义演示控制器。
         您通过视图控制器的转换委托来销售您的自定义演示控制器对象。当显示的视图控制器在屏幕上时，UIKit会保留对您的演示控制器对象的引用。
         */
        svc.presentationController!.delegate = self
        self.present(svc, animated:true)

        /// just for the one case 7/-1 we will get a real popover: we have rules about that sort of thing!
        if let pop = svc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }

    }

    func accept(data:Any!) {
        // prove that you received data
        print(data)
    }

    @IBAction func doCustomAlert(_ sender: Any?) {
        self.present(CustomAlertVC(), animated:true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }

    override func dismiss(animated: Bool, completion: (() -> Void)!) {
        print("here") // prove that this is called by clicking on curl
        super.dismiss(animated:animated, completion: completion)
    }

}

extension AdaptivePresentationVC : UIAdaptivePresentationControllerDelegate {

    //    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    //        print("adapt old!")
    //        return .overFullScreen
    //    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("adapt!")

        //        if traitCollection.horizontalSizeClass == .compact {
        //            return .overFullScreen
        //        }
        //        return .none // don't adapt
        
        /// 用于 Style 测试
        return self.adaptive
    }

    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        //
        let vc = PVCThirdVC(nibName: "PVCThirdVC", bundle: nil)
        vc.data = "This is very important data!"
        vc.delegate = self

        print("new \(vc)")
        // FIXME:vc 没有显示
        return vc
    }

    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print("will present with style: \(style.rawValue)")
    }
    
    @IBAction func dismissHelp(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
    }
    
}




