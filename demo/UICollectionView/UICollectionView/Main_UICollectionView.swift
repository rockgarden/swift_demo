//
//  Main_UICollectionView.swift
//  UICollectionView
//
//  Created by wangkan on 2017/4/18.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class Main_UICollectionView: UITableViewController {


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 11 :
            let vc = RetractableFirstItemLayoutVC()
            self.show(vc, sender: nil)
        case 12 :
            let layout = UICollectionViewFlowLayout()
            let vc = FlowLayoutTestVC(collectionViewLayout: layout)
            self.show(vc, sender: nil)
        case 13 :
            let vc = CalculateVC()
            self.show(vc, sender: nil)
        case 14 :
            let vc = UIFontFamilyVC()
            self.show(vc, sender: nil)
        case 15 :
            let vc = DynamicCellVC()
            self.show(vc, sender: nil)
        default:
            break
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


