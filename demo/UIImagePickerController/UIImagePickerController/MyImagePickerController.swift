
import UIKit

//TODO: http://www.jianshu.com/p/cd7096d29a76
class MyImagePickerController : UIImagePickerController {

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override var childViewControllerForStatusBarHidden : UIViewController? {
        return nil
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return self.presentingViewController!.supportedInterfaceOrientations
    }
}
