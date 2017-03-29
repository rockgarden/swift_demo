
import UIKit

class NibLoadingVC: UIViewController {

    @IBOutlet var coolview : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let arr = Bundle.main.loadNibNamed("NibLoading_View", owner: nil, options: nil)
        let v0 = arr?[0] as! UIView
        let v1 = arr?[1] as! UIView
        self.view.addSubview(v0)
        self.view.addSubview(v1)

        Bundle.main.loadNibNamed("NibLoading_CoolView", owner: self, options: nil)
        v1.addSubview(self.coolview)
    }

}

