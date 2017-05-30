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
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 7:
                if indexPath.section == 0 && id == 7 {
                    let vc = AddCellSubviewsbyXibVC()
                    self.show(vc,sender: nil)
                }
            case 8:
                if indexPath.section == 0 && id == 8 {
                    let vc = AddCellSubviewsbyCodeVC()
                    self.show(vc,sender: nil)
                }
            case 9:
                if indexPath.section == 0 && id == 9 {
                    let vc = InitCellbyCodeVC()
                    self.show(vc,sender: nil)
                }
            default:
                break
            }


        }
    }
    
}
