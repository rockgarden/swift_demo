
import UIKit


class PopoversVC : UIViewController, UIToolbarDelegate {
    var oldChoice : Int = -1

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Use PopoverSegue
        let dest = segue.destination
        if let pop = dest.popoverPresentationController {
            pop.delegate = self
        }

        /// 若在Storyboard中不指定使用自定义的PopoverSegue则prepare方法实现如下
        //        if segue.identifier == "MyPopover" {
        //            let dest = segue.destination
        //            if let pop = dest.popoverPresentationController {
        //                pop.delegate = self
        //                delay(0.1) {
        //                    pop.passthroughViews = nil
        //                }
        //                // pop.permittedArrowDirections = [.Up, .Down]
        //            }
        //        }

        self.oldChoice = UserDefaults.standard.integer(forKey:"choice")
    }

    @IBAction func unwindPopovers(_ sender:UIStoryboardSegue) {
        if sender.identifier == "cancel" {
            UserDefaults.standard.set(self.oldChoice, forKey: "choice")
        }
    }
}


extension PopoversVC : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("here3")
        if traitCollection.horizontalSizeClass == .compact {
            return .fullScreen
        }
        return .none
    }

    /// 不会运行, 是因为没执行Dismiss
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("here4") // not called, this could be a bug
        UserDefaults.standard.set(self.oldChoice, forKey: "choice")
    }

}


