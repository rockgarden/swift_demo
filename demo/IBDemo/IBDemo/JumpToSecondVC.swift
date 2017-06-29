

import UIKit

/// 在 Storyboard 中 引入 Storyboard Reference，可在不同的Storyboard间跳转
class JumpToSecondVC: UIViewController {

    /// 在 Second.storyboard中设置 Exit 指向 unwind
    @IBAction func unwind (_ sender: UIStoryboardSegue) {
        debugPrint(sender)
    }

}


