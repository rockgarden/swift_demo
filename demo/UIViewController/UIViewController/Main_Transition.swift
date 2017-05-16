
import UIKit

class Main_Transition: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 1:
                let vc = EvernoteCollectionVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController!.pushViewController(vc, animated: true)
            case 2:
                let vc = WaterfallCollectionVC(collectionViewLayout: CHTCollectionViewWaterfallLayout())
                vc.hidesBottomBarWhenPushed = true
                navigationController!.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
    
}
