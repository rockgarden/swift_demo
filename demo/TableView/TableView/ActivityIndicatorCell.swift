//
//  ActivityIndicatorCell.swift
//  TableView
//

/// 使用示例:
//override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    delay (2) {
//        let detail = ViewController()
//        self.tableView.selectRow(at:nil, animated: false, scrollPosition: .none)
//        self.navigationController!.pushViewController(detail, animated: true)
//    }
//}


import UIKit


/// 具有进度提示 UITableViewCell，可用于跳转准备耗时大的过程 time Consuming Navigation
class ActivityIndicatorCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            let v = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
            v.color = .yellow
            DispatchQueue.main.async {
                v.backgroundColor = UIColor(white:0.2, alpha:0.6)
            }
            v.layer.cornerRadius = 10
            v.frame = v.frame.insetBy(dx: -10, dy: -10)
            let cf = self.contentView.convert(self.bounds, from:self)
            v.center = CGPoint(x:cf.midX, y:cf.midY);
            v.frame = v.frame.integral
            v.tag = 1001
            self.contentView.addSubview(v)
            v.startAnimating()
        } else {
            if let v = self.viewWithTag(1001) {
                v.removeFromSuperview()
            }
        }
        super.setSelected(selected, animated: animated)
    }

}

