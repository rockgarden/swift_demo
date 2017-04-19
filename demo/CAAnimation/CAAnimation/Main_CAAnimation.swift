//
//  Main_CAAnimation.swift
//  CAAnimation
//
//  Created by wangkan on 2017/4/19.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_CAAnimation: UITableViewController {
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 5:
                let pvc = CAEmitterLayerVC()
                self.show(pvc, sender: nil)
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
    }
    
}
