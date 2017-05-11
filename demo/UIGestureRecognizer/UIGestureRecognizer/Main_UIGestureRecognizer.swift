//
//  Main_UIGestureRecognizer.swift
//  UIGestureRecognizer
//
//  Created by wangkan on 2016/12/2.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class Main_UIGestureRecognizer: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 2:
                let sBoard = UIStoryboard(name: "MatchItUp", bundle: nil)
                let vc = sBoard.instantiateViewController(withIdentifier: "GameViewController")
                vc.hidesBottomBarWhenPushed = true
                navigationController!.pushViewController(vc, animated: true)
            case 4:
                let vc = PanGestureViewDemo()
                vc.hidesBottomBarWhenPushed = true
                self.present(vc, animated: true, completion: nil)
            case 7:
                let vc = ScratchViewVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController!.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }

}
