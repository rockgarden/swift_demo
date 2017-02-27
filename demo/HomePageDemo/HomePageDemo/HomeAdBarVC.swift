//
//  HomeAbBarVC.swift
//  HomePageDemo
//
//  Created by wangkan on 2017/2/22.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit
import MJRefresh

fileprivate let adBarHeight: CGFloat = UIScreen.main.bounds.size.width*2/5
fileprivate let functionBarHeight: CGFloat = UIScreen.main.bounds.size.width/4

class HomeAdBarVC: UIViewController,UIScrollViewDelegate,UIGestureRecognizerDelegate {

    fileprivate let topOffsetY = 95 + UIScreen.main.bounds.size.width/4
    fileprivate var defaultAdURLStrings = ["s1","s2","s3"]
    fileprivate var adURLStrings: [String] = []
    
    lazy var mainScrollView: UIScrollView = {
        let v = UIScrollView()
        v.delegate = self
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var navView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var initToolBar: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        let payButton = UIButton(type: .custom)
        payButton.setImage(#imageLiteral(resourceName: "home_bill"), for: .normal)
        payButton.setTitle("账单", for: .normal)
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        payButton.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 0
        )
        payButton.sizeToFit()
        var newFrame = payButton.frame
        newFrame.origin.y = 20 + 10
        newFrame.origin.x = 10
        newFrame.size.width = newFrame.size.width + 10
        payButton.frame = newFrame
        v.addSubview(payButton)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var toolBar: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        let payButton = UIButton(type: .custom)
        payButton.setImage(#imageLiteral(resourceName: "pay_mini"), for: .normal)
        payButton.sizeToFit()
        var newFrame = payButton.frame
        newFrame.origin.y = 20 + 10
        newFrame.origin.x = 10
        newFrame.size.width = newFrame.size.width + 10

        payButton.frame = newFrame

        let searchButton = UIButton(type: UIButtonType.custom)
        searchButton.setImage(#imageLiteral(resourceName: "camera_mini"), for: UIControlState.normal)
        searchButton.sizeToFit()
        newFrame.origin.x = newFrame.origin.x + 40 + newFrame.size.width
        searchButton.frame = newFrame

        v.addSubview(payButton)
        v.addSubview(searchButton)

        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var mainTableView: IndexTableView = {
        let orginY =  functionBarHeight + adBarHeight
        let tableviewHeight = 1000 - orginY
        let table = IndexTableView(frame: CGRect(x: 0, y: orginY, width: SCREEN_WIDTH, height: tableviewHeight), style: .plain)
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    lazy var AdBar: LLCycleScrollView = {
        let v = LLCycleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: adBarHeight),didSelectItemAtIndex: { index in
            self.didAdSelectAtItem(index)
        })
        v.customPageControlStyle = .snake
        v.customPageControlInActiveTintColor = UIColor.blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var appHeaderView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: functionBarHeight, width: SCREEN_WIDTH, height: adBarHeight))
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var headerView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: functionBarHeight + adBarHeight))
        v.backgroundColor = UIColor(red: 65/255.0, green: 128/255.0, blue: 1, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = .white

        view.addSubview(mainScrollView)
        view.addSubview(navView)
        view.addSubview(initToolBar)
        view.addSubview(toolBar)
        addConstraint()

        mainScrollView.addSubview(headerView)
        headerView.addSubview(AdBar)
        headerView.addSubview(appHeaderView)
        mainScrollView.addSubview(mainTableView)
        
        AdBar.imagePaths = adURLStrings.count > 0 ? adURLStrings : defaultAdURLStrings

        mainTableView.changeContentSize = { [weak self] contentSize in
            guard let weak = self else {return}
            weak.updateContentSize(size: contentSize)
        }
        mainTableView.showsVerticalScrollIndicator = true
        mainTableView.mj_footer = MJRefreshAutoNormalFooter { [weak self] in
            guard let weak = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                weak.mainTableView.mj_footer.endRefreshing()
                weak.mainTableView.loadeMoreData()
            })
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateContentSize(size: self.mainTableView.contentSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didAdSelectAtItem(_ index: Int) -> Void {
        print("index\(index)")
    }

    func updateContentSize(size:CGSize) {
        var contentSize = size
        contentSize.height = contentSize.height + topOffsetY
        mainScrollView.contentSize = contentSize
        var newframe = mainTableView.frame
        newframe.size.height = size.height
        mainTableView.frame = newframe
    }

    func functionViewAnimation(offsetY y:CGFloat) {
        if y > adBarHeight/2.0 {
            self.mainScrollView.setContentOffset(CGPoint(x:0,y:95), animated: true)
        } else {
            self.mainScrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }

    // UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 松手时判断是否刷新
        let y = scrollView.contentOffset.y;

        if y < -65 {
            self.mainTableView.mj_header.beginRefreshing()
        } else if y > 0 && y <= adBarHeight {
            functionViewAnimation(offsetY: y)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y <= 0 {
            var newFrame = self.headerView.frame
            newFrame.origin.y = y
            self.headerView.frame = newFrame

            newFrame = self.mainTableView.frame
            newFrame.origin.y = y + topOffsetY
            self.mainTableView.frame = newFrame

            //偏移量给到tableview，tableview自己来滑动
            self.mainTableView.setScrollViewContentOffSet(point: CGPoint(x: 0, y: y))

            //功能区状态回归
            newFrame = self.AdBar.frame
            newFrame.origin.y = 0
            self.AdBar.frame = newFrame

        } else if y < adBarHeight && y > 0{
            //处理功能区隐藏和视差
            var newFrame = self.AdBar.frame
            newFrame.origin.y = y/2
            self.AdBar.frame = newFrame

            //处理透明度
            let alpha = (1 - y/adBarHeight*2.5 ) > 0 ? (1 - y/adBarHeight*2.5 ) : 0

            AdBar.alpha = alpha
            if alpha > 0.5 {
                let newAlpha =  alpha*2 - 1
                initToolBar.alpha = newAlpha
                toolBar.alpha = 0
            } else {
                let newAlpha =  alpha*2
                initToolBar.alpha = 0
                toolBar.alpha = 1 - newAlpha
            }
        }
    }

}


fileprivate extension HomeAdBarVC {

    fileprivate func addConstraint() {

        let views = ["nv":navView, "msv":mainScrollView, "itb":initToolBar, "tb":toolBar, "ab":AdBar, "hv":headerView]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[nv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[nv(64)]", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[nv]-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map{$0})
        
//        NSLayoutConstraint.activate([
//            AdBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
//            AdBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
//            AdBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
//            AdBar.heightAnchor.constraint(equalToConstant: adBarHeight),
//            ])
    }
}

