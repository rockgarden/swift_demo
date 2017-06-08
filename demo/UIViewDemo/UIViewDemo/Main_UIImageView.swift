//
//  Main_UIImageView.swift
//  UIViewDemo
//
//  Created by wangkan on 2017/6/8.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_UIImageView: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            let vc = ImageAnimationVC()
            self.show(vc,sender: nil)
        default:
            break
        }
    }

}
