

import UIKit

/// Storyboard Reference
class JumpToSecondVC: UIViewController {

    /// 在 Second.storyboard中设置 Exit 指向 unwind
    @IBAction func unwind (_ sender: UIStoryboardSegue) {
        debugPrint(sender)
    }

}


