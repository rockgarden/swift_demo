//
//  MainVC.swift
//  ICSLA
//
//  Created by wangkan on 2017/3/8.
//  Copyright © 2017年 eastcom. All rights reserved.
//

import MJRefresh
import Material
import Alamofire

fileprivate let functionBarHeight: CGFloat = Screen.width/5 + margin * 2
fileprivate let adBarHeight: CGFloat = Screen.width/2
fileprivate let margin: CGFloat = 3
fileprivate let toolBarHeight: CGFloat = 60
fileprivate let headerHeight = adBarHeight + functionBarHeight
fileprivate let offsetY = adBarHeight - toolBarHeight
fileprivate let minHeaderHeight = functionBarHeight + toolBarHeight
fileprivate let insetDistance: CGFloat = headerHeight - toolBarHeight
fileprivate let cardWidth: CGFloat = Screen.width
fileprivate let cardHeight: CGFloat = 120
fileprivate let minAlpha = CGFloat(0.03)
fileprivate var homepagelists : [Function] = []
fileprivate var alllists : [Function] = []


class MainVC: UIViewController {

    fileprivate var defaultAd = [CycleScrollItem("Ad_1"), CycleScrollItem("Ad_1")]
    fileprivate var newAd: [CycleScrollItem] = []
    fileprivate lazy var heights = [IndexPath: CGFloat]()
    fileprivate lazy var functionsFromPlist : [Function] = {
        return Function.getLocalFunctions()
    }()

    lazy fileprivate var headerView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy fileprivate var AdBar: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy fileprivate var functionBar: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy fileprivate var toolBar: UIView = {
        let v = UIView()
        v.backgroundColor = Color.clear
        let moreB = IconButton(image: Icon.cm.moreHorizontal, tintColor: Color.white)
        moreB.pulseColor = Color.blue.darken2
        moreB.pulseAnimation = .centerWithBacking
        moreB.addTarget(self, action: #selector(openDrawer), for: .touchUpInside)
        v.layout(moreB).width(50).height(40).bottomLeft()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy fileprivate var flowLayout: UICollectionViewFlowLayout = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 10
        fl.minimumInteritemSpacing = 10
        fl.scrollDirection = .vertical
        fl.sectionInset = UIEdgeInsetsMake(15, 0, 15, 0)
        fl.sectionFootersPinToVisibleBounds = false
        fl.estimatedItemSize = CGSize(width:cardWidth, height:cardHeight)
        return fl
    }()

    lazy fileprivate var mainScrollView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        v.backgroundColor = Color.lightGray
        v.showsVerticalScrollIndicator = true
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        v.dataSource = self
        v.contentInset = UIEdgeInsetsMake(insetDistance, 0, 0, 0)
        v.scrollIndicatorInsets = UIEdgeInsetsMake(insetDistance, 0, 0, 0)
        v.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: cardCollectionCellReuseId)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    var dataSourceItems = [DataSourceItem]()

    // MARK: View Life Cycle
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        interactiveNavigationBarHidden = true
        downLoadAllFunctions()
        view.backgroundColor = .white

        view.addSubview(mainScrollView)
        headerView.addSubview(AdBar)
        headerView.addSubview(functionBar)
        view.addSubview(headerView)
        view.addSubview(toolBar)
        loadNetMoudleData()
        addConstraint()

        AdBar.data = newAd.count > 0 ? newAd : defaultAd


        mainScrollView.mj_header = MJRefreshStateHeader { [weak self] in
            guard let weak = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                weak.mainScrollView.mj_header.endRefreshing()
                weak.prepareDataSourceItems()
                weak.mainScrollView.reloadData()
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        functionBar.dataSource.justReload()
        functionBar.collectionView.reloadData()
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainScrollView.reloadData()
    }

    // MARK: Action
    func didAdSelectAtItem(_ index: Int) -> Void {
        print("index\(index)")
    }

    func openDrawer() {
        drawerController?.openSide(.left)
    }

    fileprivate func downLoadAllFunctions() {

    }
}


// MARK: - Private Func
fileprivate extension MainVC {

    @objc fileprivate func didFunctionSelectAtItem(_ object: Any) -> Void {
        if object is Function {
            let f = object as! Function
            let vc = UIStoryboard.getViewControllerFromStoryboard(f.sbID, storyboard: f.sbName)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc fileprivate func didSelectFooter() -> Void {
        let vc = UIStoryboard.getViewControllerFromStoryboard("MoreFunctionsVC", storyboard: "Main")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    fileprivate func prepareDataSourceItems() {
        let data = [MainCardInfo(), MainCardInfo(), MainCardInfo()]

        data.forEach { [unowned self] (item) in
            self.dataSourceItems.append(DataSourceItem(data: item, height: 400))
        }
        mainScrollView.reloadData()
    }

    fileprivate func addConstraint() {

        let views = ["tb":toolBar, "ab":AdBar, "hv":headerView, "fb":functionBar, "msv":mainScrollView]
        let metrics = ["hh":headerHeight, "fbh":functionBarHeight, "th":toolBarHeight]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[hv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[hv(hh)]", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[ab]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[ab]-(0)-[fb]", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[fb]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[fb(fbh)]-(0)-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[tb]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[tb(th)]", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[tb]-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map{$0})
    }

}


// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardCollectionCellReuseId, for: indexPath) as! CardCollectionViewCell

        guard let d = dataSourceItems[indexPath.item].data as? MainCardInfo else {
            return cell
        }

        cell.data = d
        return cell
    }

}


// MARK: - UIScrollViewDelegate
extension MainVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let dY = scrollView.contentOffset.y + insetDistance

        /// 调整frame 的性能高于 直接调整 constraints.constant.
        // TODO: AutoLayout 如何局部更新?
        do {
            let originY = headerView.bounds.origin.y
            let originX = headerView.bounds.origin.x
            let w = headerView.bounds.size.width
            let h = headerView.bounds.size.height

            if dY <= 0 {
                headerView.frame = CGRect(x: originX, y: originY, width: w, height: h)
                AdBar.alpha = 1
            } else {
                headerView.frame = CGRect(x: originX,
                                          y: originY + max(-dY, -offsetY),
                                          width: w, height: h)
                AdBar.alpha = max(1 - dY/offsetY, minAlpha)
            }
        }

        return
        do {
            if dY <= 0 {
                headerView.constraints[0].constant = headerHeight
                AdBar.alpha = 1
                view.updateConstraints()
            } else {
                headerView.constraints[0].constant = max(headerHeight - dY,minHeaderHeight)
                AdBar.alpha = max(1-(dY)/(insetDistance - toolBarHeight), minAlpha)
                view.updateConstraints()
            }
        }

    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endScrollingAnimation(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        return
        endScrollingAnimation(scrollView)
    }

    private func endScrollingAnimation(_ scrollView: UIScrollView) {
        do {
            let originY = headerView.bounds.origin.y
            let originX = headerView.bounds.origin.x
            let w = headerView.bounds.size.width
            let h = headerView.bounds.size.height
            let offset = scrollView.contentOffset.y
            let foY = headerView.frame.origin.y

            if foY < -(offsetY - 20) && foY > -offsetY {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                    [weak self] _ in
                    self?.AdBar.alpha = minAlpha
                    self?.headerView.frame = CGRect(x: originX, y: -offsetY, width: w, height: h)
                    scrollView.contentOffset.y = offset + (foY + offsetY)
                })
            }

            if foY < 0 && foY > -20 {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                    [weak self] _ in
                    self?.AdBar.alpha = 1
                    self?.headerView.frame = CGRect(x: originX, y: originY, width: w, height: h)
                    scrollView.contentOffset.y = offset + foY
                })
            }
        }
        /// Debug: frame 变换不会引起 constant 变化, 这会导致 view 在重新 绘制时 frame 恢复初始值, 通过手动调整 constant 来打补丁.
        view.constraints[2].constant = headerView.frame.origin.y
    }
    
}

