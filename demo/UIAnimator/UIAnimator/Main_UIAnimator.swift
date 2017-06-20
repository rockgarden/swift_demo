

import UIKit

class Main_UIControl: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            let vc = UIFieldBehaviorVC()
            show(vc, sender: nil)
        default:
            break
        }

    }
    
}
