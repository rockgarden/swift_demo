//
//  HomeAbBarVC.swift
//  HomePageDemo
//
//  Created by wangkan on 2017/2/22.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit
import MJRefresh

fileprivate let functionBarHeight: CGFloat = UIScreen.main.bounds.size.width/4
fileprivate let adBarHeight: CGFloat = UIScreen.main.bounds.size.width/2

class HomeAdBarVC: UIViewController, UIGestureRecognizerDelegate {

    fileprivate let headerHeight = adBarHeight + functionBarHeight
    fileprivate var defaultAdURLStrings = ["s1","s2","s3"]
    fileprivate var adURLStrings: [String] = []

    lazy var headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    //TODO: 定义广告接口: Ad Image (Image 控制比例 2:5 小于 200k) , Ad Info
    lazy var AdBar: CycleScrollView = {
        let v = CycleScrollView(didSelectItemAtIndex: { index in
            self.didAdSelectAtItem(index)
        })
        v.customPageControlStyle = .snake
        v.customPageControlInActiveTintColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var functionBar: FunctionCollectionView = {
        let v = FunctionCollectionView(didSelectItemAtIndex: { index in
            self.didFunctionSelectAtItem(index)
        })
        v.backgroundColor = .white
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
        v.backgroundColor = .blue
        v.alpha = 1.0
        let defaultB = UIButton(type: .custom)
        defaultB.setImage(#imageLiteral(resourceName: "home_search"), for: .normal)
        defaultB.sizeToFit()
        var newFrame = defaultB.frame
        newFrame.origin.y = 20 + 10
        newFrame.origin.x = 10
        newFrame.size.width = newFrame.size.width + 10
        defaultB.frame = newFrame
        defaultB.translatesAutoresizingMaskIntoConstraints = true
        v.addSubview(defaultB)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var toolBar: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.alpha = 1.0

        let payB = UIButton(type: .custom)
        payB.setImage(#imageLiteral(resourceName: "home_search"), for: .normal)
        payB.sizeToFit()
        var newFrame = payB.frame
        newFrame.origin.y = 20 + 10
        newFrame.origin.x = 10
        newFrame.size.width = newFrame.size.width + 10
        payB.frame = newFrame
        payB.translatesAutoresizingMaskIntoConstraints = true

        let cameraB = UIButton(type: .custom)
        cameraB.setImage(#imageLiteral(resourceName: "camera_mini"), for: .normal)
        cameraB.sizeToFit()
        newFrame.origin.x = newFrame.origin.x + 40 + newFrame.size.width
        cameraB.frame = newFrame
        cameraB.translatesAutoresizingMaskIntoConstraints = true

        v.addSubview(payB)
        v.addSubview(cameraB)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var mainScrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .gray
        v.delegate = self
        v.showsVerticalScrollIndicator = true
        v.showsHorizontalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(mainScrollView)
        view.addSubview(navView)
        view.addSubview(initToolBar)
        view.addSubview(toolBar)


        headerView.addSubview(AdBar)
        headerView.addSubview(functionBar)

        addConstraint()
        
        AdBar.imagePaths = adURLStrings.count > 0 ? adURLStrings : defaultAdURLStrings

        mainScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        mainScrollView.mj_header = MJRefreshStateHeader { [weak self] in
            guard let weak = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                weak.mainScrollView.mj_header.endRefreshing()
                //weak.scrollView.refreshData()
            })
        }
        mainScrollView.mj_footer = MJRefreshAutoNormalFooter { [weak self] in
            guard let weak = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                weak.mainScrollView.mj_footer.endRefreshing()
                //weak.scrollView.loadeMoreData()
            })
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Action
    func didAdSelectAtItem(_ index: Int) -> Void {
        print("index\(index)")
    }
    
    func didFunctionSelectAtItem(_ index: Int) -> Void {
        print("index\(index)")
    }

}


// MARK: - Add Constraint
fileprivate extension HomeAdBarVC {

    fileprivate func addConstraint() {

        let views = ["nv":navView, "msv":mainScrollView, "itb":initToolBar, "tb":toolBar, "ab":AdBar, "hv":headerView, "fb":functionBar]
        let metrics = ["hh":headerHeight, "fbh":functionBarHeight]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[hv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[hv(hh)]", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[fb]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[fb(fbh)]-(0)-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[ab]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[ab]-(0)-[fb]", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[nv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[nv(60)]", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[hv]-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map{$0})
    }
}


// MARK: - UIScrollViewDelegate
extension HomeAdBarVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        debugPrint("contentOffset:", y)
        if y <= 0 {
        } else if y < adBarHeight - 60 && y > 0 {
            //处理透明度
            let alpha = (1 - y/adBarHeight*2.5 ) > 0 ? (1 - y/adBarHeight*2.5 ) : 0
            debugPrint("alpha:", alpha)
            AdBar.alpha = alpha
            if alpha > 0.5 {
                let newAlpha =  alpha*2 - 1
                initToolBar.alpha = newAlpha
                toolBar.alpha = 0
            } else {
                let newAlpha =  alpha * 2
                initToolBar.alpha = 0
                toolBar.alpha = 1 - newAlpha
            }
            headerView.constraints[0].constant = headerHeight - y
            //view.updateConstraints()
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
}
