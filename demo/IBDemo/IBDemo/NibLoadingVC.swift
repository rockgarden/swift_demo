
import UIKit

class NibLoadingVC: UIViewController {

    @IBOutlet var coolview : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 不指明 File's Owner
        let arr = Bundle.main.loadNibNamed("NibLoading_View", owner: nil, options: nil)
        let v0 = arr?[0] as! UIView
        let v1 = arr?[1] as! UIView
        // 证实 可加载多个View
        print(v0.tag,v1.tag)

        view.addSubview(v0)
        view.addSubview(v1)

        // 指明 File's Owner
        Bundle.main.loadNibNamed("NibLoading_CoolView", owner: self, options: nil)
        v1.addSubview(self.coolview)
    }

}

