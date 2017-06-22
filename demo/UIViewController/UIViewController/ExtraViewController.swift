

import UIKit

class ExtraViewController : UIViewController {

    @IBOutlet var closeB: UIButton!
    var which = 1
        
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        closeB.setTitle("Case \(which)", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.traitCollection)
    }
    
    @IBAction func doButton (_ sender: Any) {
        print("presented vc's presenting vc: \(String(describing: presentingViewController))")
        presentingViewController!.dismiss(animated:true)
    }
}
