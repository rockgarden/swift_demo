
import UIKit

class EIRRCell : UITableViewCell {
    @IBOutlet weak var textField : UITextField!
    override func didTransition(to state: UITableViewCellStateMask) {
        self.textField.isEnabled = state.contains(.showingEditControlMask)
        super.didTransition(to:state)
    }
}
