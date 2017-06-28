//
//  Main_QuartzCore.swift
//  QuartzCoreDemo
//
//  Created by wangkan on 2017/6/28.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_QuartzCore: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            let vcInstance = CATransformLayerVC()
            navigationController?.pushViewController(vcInstance, animated: true)
        default:
            break
        }

    }
    
}
