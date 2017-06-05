
import UIKit

class TodayExtensionVC: UIViewController {

    @IBOutlet var showInfo: UILabel!

    private var _info = ""

    var info: String {
        get {
            return _info
        }
        set {
            _info = newValue
            showInfo.text = _info
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

