//
//  Main.swift
//  UIGestureRecognizer
//
//  Created by wangkan on 2016/12/2.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class RootVC: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.reuseIdentifier {
            switch id {
            case "MatchItUp":
                let sBoard = UIStoryboard(name: "MatchItUp", bundle: nil)
                let vc = sBoard.instantiateViewController(withIdentifier: "GameViewController")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController!.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }

}
