
import UIKit

class RootVC_ScrollView: UITableViewController {

    var w = -1
    var sw = 0

    let classes: Array<UIViewController.Type> = [ScrollViewVC.self, ScrollWithTilingVC.self]

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 0:
                let vcClass = classes[id]
                let vcInstance = vcClass.init() as! ScrollViewVC
                w = w < 2 ? w + 1 : 2
                vcInstance.which = w
                if w == 2 {
                    sw = sw < 4 ? sw + 1 : 1
                    vcInstance.subWhich = sw
                }
                vcInstance.title = vcInstance.description
                navigationController?.pushViewController(vcInstance, animated: true)
            case 6:
                let vcClass = classes[1]
                let vcInstance = vcClass.init() as! ScrollWithTilingVC
                vcInstance.title = vcInstance.description
                navigationController?.pushViewController(vcInstance, animated: true)
            default:
                break
            }
        }
    }
}
