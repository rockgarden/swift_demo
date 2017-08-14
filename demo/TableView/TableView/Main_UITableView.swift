//
//  Main_UITableView'.swift
//  TableView
//
//  Created by wangkan on 2017/5/30.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_UITabView: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 13:
            let vc = DynamicTableVC()
            self.show(vc,sender: nil)
        case 2:
            let vc = SectionsVC()
            self.show(vc,sender: nil)
        case 7:
            let vc = AddCellSubviewsbyXibVC()
            self.show(vc,sender: nil)
        case 8:
            let vc = AddCellSubviewsbyCodeVC()
            self.show(vc,sender: nil)
        case 9:
            let vc = InitCellbyCodeVC()
            self.show(vc,sender: nil)
        case 10:
            let vc = RowActionsVC()
            self.show(vc,sender: nil)
        case 11:
            let vc = CellMenusVC()
            self.show(vc,sender: nil)
        case 12:
            let vc = CellBackgroundLayeringVC()
            self.show(vc,sender: nil)
        case 14:
            let vc = UIStoryboard(name: "PickACell", bundle: nil).instantiateViewController(withIdentifier: "PickACellVC")
            show(vc,sender: nil)
        case 15:
            let vc = EditInsertAndRearrangeRowsVC()
            show(vc,sender: nil)
        default:
            break
        }
    }
    
}
