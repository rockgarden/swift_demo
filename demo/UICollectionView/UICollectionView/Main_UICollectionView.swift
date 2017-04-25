//
//  Main_UICollectionView.swift
//  UICollectionView
//
//  Created by wangkan on 2017/4/18.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_UICollectionView: UITableViewController {

    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 11 :
                let pvc = RetractableFirstItemLayoutVC()
                self.show(pvc, sender: nil)
            case 12 :
                let layout = UICollectionViewFlowLayout()
                let pvc = FlowLayoutTestVC(collectionViewLayout: layout)
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


internal extension Notification.Name {
    static let tap = Notification.Name("tap")
}


