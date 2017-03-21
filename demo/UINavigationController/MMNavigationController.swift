//
// FIXME: 由于Swift不能重写load方法，所以需要在AppDelegate中调用UIViewController.mm_load()?
// FIXME: Bug! Bug!
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        UIViewController.mm_load()
//        window = UIWindow(frame: UIScreen.main.bounds)
//        let rootViewController = MMNavigationController(rootViewController: NormalViewController())
//        rootViewController.hideBottomLine()
//        window?.rootViewController = rootViewController
//        window?.makeKeyAndVisible()
//        return true
//    }
//
//}

//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    /// 修改当前ViewContoller的导航栏的背景颜色
//    mm_navigationBarBackgroundColor = UIColor.randomColor()
//
//    /// 修改当前ViewContoller标题颜色
//    mm_navigationBarTitleColor = UIColor.whiteColor()
//
//    /// 隐藏当前ViewContoller的导航栏
//    mm_navigationBarHidden = true
//
//    /** 全屏手势相关属性 **/
//
//    /// pop 手势是否可用
//    mm_popGestrueEnable = false
//
//    /// pop 手势响应的范围
//    mm_popGestrueEnableWidth = 150
//
//}


import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


extension UIViewController {

    fileprivate struct AssociatedKey {
        static var viewWillAppearInjectBlock = 0
        static var navigationBarHidden = 0
        static var popGestrueEnable = 0
        static var navigationBarBackgroundColor = 0
        static var popGestrueEnableWidth = 0
        static var navigationBarTitleColor = 0
    }

    /// 在AppDelegate中调用此方法
    class func mm_load() {
        // 'dispatch_once' is unavailable in Swift: Use lazily initialized globals instead
        struct Static {
            static var _token: Int?
        }

        objc_sync_enter(self)
        if Static._token == nil {
            Static._token = 0
            let originalViewWillAppearSelector = class_getInstanceMethod(self, #selector(viewWillAppear(_:)))
            let swizzledViewWillAppearSelector = class_getInstanceMethod(self, #selector(mm_viewWillAppear(_:)))
            method_exchangeImplementations(originalViewWillAppearSelector, swizzledViewWillAppearSelector)
        }
        objc_sync_exit(self)
    }

    /// navigationBar 是否隐藏
    @objc var mm_navigationBarHidden: Bool {
        get {
            var hidden = objc_getAssociatedObject(self, &AssociatedKey.navigationBarHidden) as? Bool
            if hidden == nil {
                hidden = false
                objc_setAssociatedObject(self, &AssociatedKey.navigationBarHidden, hidden, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return hidden!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// pop 手势是否可用
    @objc var mm_popGestrueEnable: Bool {
        get {
            var enable = objc_getAssociatedObject(self, &AssociatedKey.popGestrueEnable) as? Bool
            if enable == nil {
                enable = true
                objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnable, enable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return enable!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// pop手势可用宽度，从左开始计算
    @objc var mm_popGestrueEnableWidth: CGFloat {
        get {
            var width = objc_getAssociatedObject(self, &AssociatedKey.popGestrueEnableWidth) as? CGFloat
            if width == nil {
                width = 0
                objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnableWidth, width, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return width!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnableWidth, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// navigationBar 背景颜色
    @objc var mm_navigationBarBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.navigationBarBackgroundColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// navigationBar 标题字体颜色
    @objc var mm_navigationBarTitleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.navigationBarTitleColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK - private methods
    @objc fileprivate func mm_viewWillAppear(_ animated: Bool) {
        mm_viewWillAppear(animated)
        mm_viewWillAppearInjectBlock?.block?(self, animated)
    }

    @objc fileprivate var mm_viewWillAppearInjectBlock: ViewControllerInjectBlockWrapper? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewWillAppearInjectBlock) as? ViewControllerInjectBlockWrapper
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewWillAppearInjectBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

class MMNavigationController: UINavigationController {

    // MARK: - properties

    /// navgation bar 默认背景颜色
    var defaultNavigationBarBackgroundColor = UIColor.white

    /// navgation bar 默认标题颜色
    var defaultTitleColor = UIColor.black

    /// full screen 手势
    lazy var fullscreenInteractivePopGestureRecognizer = UIPanGestureRecognizer()

    /// navigation bar 主体视图，此属性用于兼容 iOS 10
    fileprivate var barBackgoundView: UIView? {
        if #available(iOS 10.0, *) {
            for view in navigationBar.subviews {
                if NSClassFromString("_UIBarBackground").flatMap(view.isKind(of:)) == true {
                    return view
                }
            }
        }
        return nil
    }

    fileprivate lazy var popGestrueDelegate: MMNavigationControllerPopGestrueDelegate = {
        let delegate = MMNavigationControllerPopGestrueDelegate()
        delegate.navigationController = self
        return delegate
    }()

    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        initFullscreenGesture()

        /// 导航栏设置为不透明,UIViewController的view会自动向下偏移 64
        /// viewController.extendedLayoutIncludesOpaqueBars = true
        /// 以上设置可以解决这个问题
        navigationBar.isTranslucent = false
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBarBackgroundColor(defaultNavigationBarBackgroundColor, animated: false)
    }


    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        let blockWrapper = ViewControllerInjectBlockWrapper { (viewController: UIViewController, animated: Bool) -> Void in

            viewController.navigationController?
                .setNavigationBarHidden(viewController.mm_navigationBarHidden, animated: animated)

            if let navigationController = viewController.navigationController as? MMNavigationController {

                let navigationBarBackgroundColor = viewController.mm_navigationBarBackgroundColor ?? navigationController.defaultNavigationBarBackgroundColor
                navigationController.setBarBackgroundColor(navigationBarBackgroundColor, animated: true)

                let titleColor = viewController.mm_navigationBarTitleColor ?? navigationController.defaultTitleColor
                navigationController.setTitleColor(titleColor)
            }
            let navigationBarBackgroundColor = viewController.mm_navigationBarBackgroundColor ?? self.defaultNavigationBarBackgroundColor
            (viewController.navigationController as? MMNavigationController)?.setBarBackgroundColor(navigationBarBackgroundColor, animated: true)

        }
        viewController.mm_viewWillAppearInjectBlock = blockWrapper
        viewControllers.last?.mm_viewWillAppearInjectBlock = blockWrapper
        super.pushViewController(viewController, animated: animated)
    }


    // MARK: - private methods

    fileprivate func initFullscreenGesture() {

        fullscreenInteractivePopGestureRecognizer.delegate = popGestrueDelegate
        guard let targets = interactivePopGestureRecognizer?.value(forKey: "targets") as? [AnyObject] else { return }
        guard let target = (targets.first as? NSObject)?.value(forKey: "target") else { return }
        let internalAction = NSSelectorFromString("handleNavigationTransition:")
        fullscreenInteractivePopGestureRecognizer.maximumNumberOfTouches = 1
        fullscreenInteractivePopGestureRecognizer.addTarget(target, action: internalAction)
        interactivePopGestureRecognizer?.isEnabled = false
        interactivePopGestureRecognizer?.view?.addGestureRecognizer(fullscreenInteractivePopGestureRecognizer)
    }

    // MARK: - public methods

    /// 设置 title 的字体颜色
    func setTitleColor(_ textColor: UIColor){
        if navigationBar.titleTextAttributes == nil{
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : textColor]
        }else{
            navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = textColor
        }
    }

    /// 隐藏 navigation bar 底部灰线
    func hideBottomLine() {
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    /// 设置返回按钮图片
    func setBackButtonImage(_ image: UIImage){
        let backButtonImage = image.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backButtonImage
        navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }

    /// 设置 navigation bar 背景颜色
    func setBarBackgroundColor(_ color: UIColor, animated: Bool) {
        let duration = animated ? 0.25 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.navigationBar.barTintColor = color
            self.barBackgoundView?.backgroundColor = color
        })
    }
}


// MARK: - NavigationControllerPopGestrueDelegate
private class MMNavigationControllerPopGestrueDelegate: NSObject {

    weak var navigationController: UINavigationController?

}

// MARK: - UIGestureRecognizerDelegate
extension MMNavigationControllerPopGestrueDelegate: UIGestureRecognizerDelegate {


    /// 这里主要参考了 FDFullscreenPopGesture
    @objc fileprivate func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if navigationController?.viewControllers.count <= 1 {
            return false
        }

        let topViewController = navigationController?.viewControllers.last
        if topViewController?.mm_popGestrueEnable == false {
            return false
        }

        let startLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let enableWidth = topViewController?.mm_popGestrueEnableWidth
        if enableWidth > 0 && startLocation.x > enableWidth {
            return false
        }

        if navigationController?.value(forKey: "_isTransitioning") as? Bool == true {
            return false
        }

        let translation = (gestureRecognizer as? UIPanGestureRecognizer)?.translation(in: gestureRecognizer.view)
        if translation?.x <= 0 {
            return false
        }

        return true
    }

}

@objc private class ViewControllerInjectBlockWrapper: NSObject {

    var block: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?

    init(block: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?) {
        self.block = block
        super.init()
    }
    
}
