//
//  DetailViewController.swift
//  swiftDemo
//
//  Created by LinfangTu on 15/12/2.
//  Copyright © 2015年 LinfangTu. All rights reserved.
//

import UIKit

let ID = "Cell" //cell的ID，建议像这样写一个常量，不要直接使用"Cell"


class UIViewController_table_1: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataArray : [String] = NSArray(objects: "To enable string bridging, just import Foundation. For example, you can access capitalizedString—a property on the NSString class—on a Swift string, and Swift automatically bridges the Swift String to an NSString object and accesses the property. The property even returns a Swift String type, because it was converted during import.", "其中针对table cell高度自动计算的 UITableViewAutomaticDimension 异常好用，但好像只对uilabel对象有效" ,"当cell中内容比较复杂，比如涉及图文混排或加上其他动态高度的元素，自动高度就失效了", "To enable string bridging", "just import Foundation. For example, you can access capitalizedString—a property on the NSString class—on a Swift string, and Swift automatically bridges the", "从self.tableData中的数据我们可以看到，每一个Cell显示的数据高度是不一样的，那么我们需要动态计算Cell的高度。", "要求返回一个Cell的估计值，实现了这个方法，那只有显示的Cell才会触发计算高度的protocol. 由于systemLayoutSizeFittingSize需要cell的一个实例才能计算，所以这儿用一个成员变量存一个Cell的实列，这样就不需要每次计算Cell高度的时候去动态生成一个Cell实例，这样即方便也高效也少用内存，可谓一举三得。") as! [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "详情"
        self.view.backgroundColor = UIColor.white

        let tableView : UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.layoutIfNeeded()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //2.注册Cell
        tableView.register(UITableViewCell_photo_1.self, forCellReuseIdentifier: ID)
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let views:[String:AnyObject] = ["tableView": tableView]
        //创建水平方向约束
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))

        //创建垂直方向约束
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 计算cell的高度
    
    func cellHeightByString(_ content : String) -> CGFloat {
        
        let height = content.stringHeightWith(12, width:kScreenWidth-110)

        return 50.0+height
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    /**
     计算高度
     
     - parameter tableView: heightForRowAtIndexPath
     - parameter indexPath: indexPath
     
     - returns: 固定高度+文字高度
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightByString(dataArray[(indexPath as NSIndexPath).row]) > 80 ? cellHeightByString(dataArray[(indexPath as NSIndexPath).row]) : 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 获得cell
        let cell : UITableViewCell_photo_1 = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! UITableViewCell_photo_1
        

        // 配置cell
        if (indexPath as NSIndexPath).row%2 == 0 {
            cell.photoView.image = UIImage(named: "photo")
        }
        else {
            cell.photoView.image = UIImage(named: "photo1")
        }
        
        cell.titleLabel.text = "假数据 - \((indexPath as NSIndexPath).row)"
        
        cell.descLabel.text = dataArray[(indexPath as NSIndexPath).row]
        
        // 返回cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected index row - \((indexPath as NSIndexPath).row)")
    }

}


extension String {
    
    //MARK:获得string内容高度
    
    func stringHeightWith(_ fontSize:CGFloat, width:CGFloat) -> CGFloat{
        
        let font                     = UIFont.systemFont(ofSize: fontSize)
        
        let size                     = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle           = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes               = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text                     = self as NSString
        
        let rect                     = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height+1.0
        
    }//funcstringHeightWith
    
}//extension end
