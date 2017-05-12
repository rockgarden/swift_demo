
import UIKit

class Main_CoreGraphics: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 6:
                let vc = RectGridVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController!.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }

}
