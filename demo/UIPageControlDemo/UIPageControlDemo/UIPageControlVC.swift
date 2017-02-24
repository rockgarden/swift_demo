//
//  UIPageControlVC.swift
//  UIPageControlDemo
//
//  Created by wangkan on 2017/2/24.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class UIPageControlVC : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var pager : UIPageControl!
    let colors : [UIColor] = [.purple, .green, .yellow, .blue]
    var views: [UIView] = []
    
    var didLayout = false
    
    override func viewDidLoad() {
        demoMU()
    }
    
    override func viewDidLayoutSubviews() {
        if !self.didLayout {
            self.didLayout = true
            let sz = self.sv.bounds.size
            for i in 0 ..< 4 {
                let v = UIView(frame:CGRect(sz.width*CGFloat(i),0,sz.width,sz.height))
                v.backgroundColor = colors[i]
                self.sv.addSubview(v)
                views.append(v)
            }
            self.sv.contentSize = CGSize(3*sz.width,sz.height)
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
    
    func demoMU() {
        
        let y = self.sv.frame.maxY + 40;
        let roundCycleView: MUCycleScrollView = MUCycleScrollView(frame: CGRect(x: 0, y: y, width: self.view.bounds.size.width, height: 200))
        self.view.addSubview(roundCycleView)
        
        //设置数据源
        roundCycleView.imageArray = views
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
        roundCycleView.scrollDirection = .vertical
        //图片填充样式
        roundCycleView.bannerImageContentMode = .scaleAspectFill
        //点击回调
        roundCycleView.selectItem = didSelectItem
    }
    
    func didSelectItem(index: Int) -> Void {
        print("index\(index)")
    }
}

