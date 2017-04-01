//
//  UIPageControlDemo.swift
//  UIPageControlDemo
//
//  Created by wangkan on 2017/2/24.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class UIPageControlDemo : UIViewController {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var pager : UIPageControl!
    let colors : [UIColor] = [.purple, .green, .yellow, .blue]
    var views: [UIView] = []
    var images = [UIImage]()
    
    var didLayout = false
    
    override func viewDidLoad() {
        /// for MUCycleScrollView data
        for i in 0 ..< colors.count {
            let i = UIImage(color: colors[i], rect: CGRect(0, 0, view.bounds.width, view.bounds.height))
            images.append(i)
        }
        demoMU()

        /// 在 StoryBoard 中关闭 Adjusts ScrollView Insets
        pager.numberOfPages = colors.count
    }
    
    override func viewDidLayoutSubviews() {
        setContentSize()
    }
}


// MARK: - MUCycleScrollView Demo
extension UIPageControlDemo {
    fileprivate func demoMU() {
        let roundCycleView = MUCycleScrollView()
        roundCycleView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(roundCycleView)
        let vs = ["rcv":roundCycleView, "sv":sv] as [String : Any]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[rcv]-(0)-|", options: [], metrics: nil, views: vs),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[sv]-(2)-[rcv(200)]", options: [], metrics: nil, views: vs),
            ].joined().map{$0})

        
        //设置数据源
        roundCycleView.imageArray = images
        //无限滚动
        roundCycleView.infiniteLoop = true
        //自动滚动
        roundCycleView.autoScroll = true
        //自动滚动时间
        roundCycleView.autoScrollTimeInterval = 4
        //是否显示title
        roundCycleView.showTitleLabel = false
        //是否显示分页控件
        roundCycleView.showPageControl = true;
        //滚动方向
        roundCycleView.scrollDirection = .horizontal
        //图片填充样式
        roundCycleView.bannerImageContentMode = .scaleAspectFill
        //点击回调
        roundCycleView.selectItem = didSelectItem
    }
    
    func didSelectItem(index: Int) -> Void {
        print("index\(index)")
    }
}


// MARK: - PageControl Demo
extension UIPageControlDemo: UIScrollViewDelegate {

    fileprivate func setContentSize() {
        if !self.didLayout {
            self.didLayout = true
            let sz = self.sv.bounds.size
            for i in 0 ..< colors.count {
                let v = UIView(frame:CGRect(sz.width*CGFloat(i), 0, sz.width, sz.height))
                v.backgroundColor = colors[i]
                self.sv.addSubview(v)
            }
            self.sv.contentSize = CGSize(CGFloat(colors.count)*sz.width,sz.height)
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("begin")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("end")
        let x = self.sv.contentOffset.x
        let w = self.sv.bounds.size.width
        let p = self.pager.currentPage
        debugPrint("x:",x,"w:",w,"p:",p)
        self.pager.currentPage = Int(x/w)
    }

    @IBAction func userDidPage(_ sender: Any?) {
        let p = self.pager.currentPage
        let w = self.sv.bounds.size.width
        self.sv.setContentOffset(CGPoint(CGFloat(p)*w,0), animated:true)
    }
}

