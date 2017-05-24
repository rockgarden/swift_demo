
import UIKit

class Main_UIControl: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 0:
                let vcInstance = UISegmentedControlVC()
                navigationController?.pushViewController(vcInstance, animated: true)
            case 5:
                let vcInstance = RefreshControlVC()
                navigationController?.pushViewController(vcInstance, animated: true)
            default:
                break
            }
        }
    }
    
}
