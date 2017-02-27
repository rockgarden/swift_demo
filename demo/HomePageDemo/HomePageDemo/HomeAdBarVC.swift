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
fileprivate let adBarHeight: CGFloat = UIScreen.main.bounds.size.width*2/5

class HomeAdBarVC: UIViewController, UIGestureRecognizerDelegate {

    fileprivate let headerHeight = adBarHeight + functionBarHeight
    fileprivate var defaultAdURLStrings = ["s1","s2","s3"]
    fileprivate var adURLStrings: [String] = []

    lazy var headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var AdBar: CycleScrollView = {
        let v = CycleScrollView(didSelectItemAtIndex: { index in
            self.didAdSelectAtItem(index)
        })
        v.customPageControlStyle = .snake
        v.customPageControlInActiveTintColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var functionBar: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
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
        v.backgroundColor = .clear

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
        AdBar.frame = AdBar.bounds
        debugPrint(AdBar.frame)
        
        //AdBar.imagePaths = adURLStrings.count > 0 ? adURLStrings : defaultAdURLStrings

        mainScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
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
        //self.updateContentSize(size: mainTableView.contentSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didAdSelectAtItem(_ index: Int) -> Void {
        print("index\(index)")
    }

}


// MARK: - Add Constraint
fileprivate extension HomeAdBarVC {

    fileprivate func addConstraint() {

        let views = ["nv":navView, "msv":mainScrollView, "itb":initToolBar, "tb":toolBar, "ab":AdBar, "hv":headerView]

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),
            AdBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            AdBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            AdBar.topAnchor.constraint(equalTo: headerView.topAnchor),
            AdBar.bottomAnchor.constraint(equalTo: functionBar.topAnchor),
            functionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            functionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            functionBar.heightAnchor.constraint(equalToConstant: functionBarHeight),
            functionBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            ])

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[nv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[nv(64)]", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[hv]-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map{$0})
    }
}


// MARK: - UIScrollViewDelegate
extension HomeAdBarVC: UIScrollViewDelegate {

//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        // 松手时判断是否刷新
//        let y = scrollView.contentOffset.y;
//
//        if y < -65 {
//            self.mainTableView.mj_header.beginRefreshing()
//        } else if y > 0 && y <= functionBarHeight {
//            functionViewAnimation(offsetY: y)
//        }
//    }



    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        debugPrint("contentOffset:", y)
        if y <= 0 {
            //处理功能区隐藏和视差
            var newFrame = self.AdBar.frame
            newFrame.origin.y = y/2
            self.AdBar.frame = newFrame

            //处理透明度
            let alpha = (1 - y/functionBarHeight*2.5 ) > 0 ? (1 - y/functionBarHeight*2.5 ) : 0

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
        } else if y < adBarHeight && y > 0 {
            debugPrint(headerView.constraints)
            headerView.constraints[0].constant = headerHeight - y
            //view.updateConstraints()
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
}
