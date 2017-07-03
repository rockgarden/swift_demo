//
//  Main_animate.swift
//  UIViewDemo
//
//  Created by wangkan on 2017/7/2.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_animate: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = VisualEffectAnimationVC()
            show(vc,sender: nil)
        default:
            break
        }
    }
    
}
