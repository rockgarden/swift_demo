
import UIKit

class RootViewController : UIViewController {

//    init() {
//        super.init(nibName:"RootViewController", bundle:nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    override var nibName : String {
//        get {
//            return "RootView"
//        }
//    }
}

/// 加载nib解决方法
/// ?workaround 1: change the xib name to match the swift name by prepending the module name 通过添加模块名称来更改xib名称以匹配swift名称, nib 指定 File's Owner 是 class RootViewController
/// ?workaround 2 RootViewController(): change the swift name by using @objc() notation 使用@objc（）表示法更改swift名称
/// ?名称关联的工作，即使“控制器”被剥离了xib名称;proving that, once we've got the name association working, it works even if "Controller" is stripped off the xib name
@objc(RootViewController) class RootVC : UIViewController { }
/// workaround 3: have the view controller provide its own nib name explicitly

/// workaround 4: proving that device-specific nibs do still work ,like "RootView~ipad.xib"

// workaround 5: override the `nibName` getter
