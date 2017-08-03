
import UIKit
/*
 标准体系结构 用于 获取 从 源 vc 到 presented vc 和 presented vc 消失时 的消息
 Standard architecture for handing info from vc to presented vc...
 ...and back when presented vc is dismissed
  */

protocol PVCSecondVCDelegate : class {
    func accept(data:Any!)
}

class PVCSecondVC : UIViewController {

    var data : Any?
    weak var delegate : PVCSecondVCDelegate?

    @IBAction func doDismiss(_ sender: Any?) {
        // logging to show relationships
        print(self.presentingViewController!)
        print(self.presentingViewController!.presentedViewController as Any)
        let vc = self.delegate as! UIViewController
        print(vc.presentedViewController as Any)

        // just proving it works
        // self.dismiss(animated:true)
        // vc.dismiss(animated:true)
        // return;

        presentingViewController?.dismiss(animated:true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        print(self.data as Any)
        print(self.traitCollection)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.delegate?.accept(data:"Even more important data!")
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("new size coming: \(size)")
    }

}
