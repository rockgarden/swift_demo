
import UIKit

class RootVC_ScroolView: UITableViewController {
    let classes: Array<UIViewController.Type> = [ScrollViewVC.self]

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 0:
                let vcClass = classes[id]
                let vcInstance = vcClass.init() as! ScrollViewVC
                vcInstance.which = 2
                vcInstance.subWhich = 4
                vcInstance.title = vcInstance.description
                self.navigationController?.pushViewController(vcInstance, animated: true)
            default:
                break
            }
        }
    }
}
