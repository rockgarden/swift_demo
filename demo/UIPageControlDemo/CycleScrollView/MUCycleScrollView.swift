//
//  MUCycleScrollView.swift
//  MUCycleScrollView
//
//  Created by qcm on 16/12/15.
//  Copyright © 2016年 ChengziVR. All rights reserved.
//

import UIKit
//import Kingfisher

enum PageControlAligment: Int {
        case left, center, right
        
        func pageLocation(pageSize: CGSize, edgeInset: UIEdgeInsets, size: CGSize) -> CGPoint
        {
                let y = size.height - pageSize.height + edgeInset.top;
                switch self {
                case .left:
                        let x = edgeInset.left
                        return CGPoint(x: x, y: y)
                case .center:
                        let x = (size.width - pageSize.width) * 0.5 + edgeInset.left - edgeInset.right
                        return CGPoint(x: x, y: y)
                default:
                        let x = (size.width - pageSize.width) + edgeInset.left - edgeInset.right
                        return CGPoint(x: x, y: y)
                }
        }
}


typealias didSelectItem = (_ index: Int)->Void

class MUCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
        
        /// 点击回调闭包(可选类型)
        var selectItem: didSelectItem?
        
        /// title
        var titleArray: [String?] = [] {
                didSet {
                        self.collectionView.reloadData()
                }
        }
        
        /// 图片数组
        var imageArray: [UIImage] = [] {
                willSet {
                        dataSource = newValue
                }
        }
        /// 链接数组
        var imageURLArray: [String] = [] {
                willSet {
                        dataSource = newValue
                }
        }

        /// 数据源
        private var dataSource: [Any] = [] {
                didSet {
                        self.pageControl.numberOfPages = dataSource.count
                        self.totalItems = dataSource.count * times
                        setupPageController()
                        self.collectionView.reloadData()
                }
        }
        
        
        //////////////////////  自定义样式接口  //////////////////////
        
        /// 占位图片
        var placeHolderImage: UIImage? {
                didSet {
                        self.collectionView.reloadData()
                }
        }
        
        /// 轮播图的ContentMode
        var bannerImageContentMode: UIViewContentMode = .scaleAspectFill {
                
                didSet {
                        self.collectionView.reloadData()
                }
        }
        
        /// 是否显示分页控件
        var showPageControl: Bool = true {
                
                didSet {
                        self.pageControl.isHidden = !showPageControl
                }
        }
        
        /// 是否只有一张图时，隐藏分页控件
        var hidesForSinglePage: Bool = true {
                
                didSet {
                        self.pageControl.isHidden = hidesForSinglePage;
                }
        }
        
        /// 分页控件位置
        var pageControlAligment: PageControlAligment = .center {
                
                didSet {
                        setNeedsLayout()
                }
        }
        
        /// 分页控件的偏移量
        var pageControlEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10) {
                
                didSet {
                        setNeedsLayout()
                }
        }
        
        /// 当前分页Dot颜色
        var curPageDotColor: UIColor = .orange {
        
                didSet {
                        self.pageControl.pageControl.currentPageIndicatorTintColor = curPageDotColor;
                }
        }
        
        /// 其他分页Dot颜色
        var pageDotColor: UIColor = .darkGray {
                
                didSet {
                        self.pageControl.pageControl.pageIndicatorTintColor = pageDotColor;
                }
        }
        
        /// 是否显示轮播图文字
        var showTitleLabel: Bool = true
        
        /// 轮播图文字颜色
        var titleTextColor: UIColor = .white
        
        /// 轮播图文字大小
        var titleTextFont: UIFont = UIFont.systemFont(ofSize: 17)
        
        /// 轮播图文字对齐方式
        var titleTextAligment: NSTextAlignment = .left
        
        /// 轮播图文字偏移
        var titleEdgeInsets: UIEdgeInsets = .zero

        /// 轮播图文字背景色
        var titleBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.3)
        
        /// 轮播图文字高度
        var titleLabelHeight: CGFloat = 30.0 {
                
                didSet {
                        self.collectionView.reloadData()
                }
        }
        
         //////////////////////  滚动控制接口  //////////////////////
        
        /// 滚动方向
        var scrollDirection: UICollectionViewScrollDirection = .horizontal {
                willSet {
                        print("方向 will Set")
                }
                didSet {
                        flowLayout.scrollDirection = scrollDirection
                        self.collectionView.reloadData()
                }
        }
        
        /// 自动滚动间隔时间， 默认2秒
        var autoScrollTimeInterval: TimeInterval = 2.0 {
                didSet {
                        invalidateTimer()
                        if self.autoScroll {
                                //重新启动计时器
                                setupTimer()
                        }
                }
        }
        
        /// 是否无限滚动, 默认true
        var infiniteLoop: Bool = true
        
        /// 是否自动滚动,默认Yes
        var autoScroll: Bool = true {
                
                didSet {
                        invalidateTimer()
                        if autoScroll {
                                // 重新启动计时器
                                setupTimer()
                        }
                }
        }
        
        /// 增加倍数
        private let times: Int = 100
        
        /// 总共的item
        private var totalItems: Int = 0

        /// 计时器
        var timer: Timer?
        
        /// lazy method - UI
        lazy var flowLayout: UICollectionViewFlowLayout = {
                let tempFlowLayout = UICollectionViewFlowLayout()
                tempFlowLayout.minimumLineSpacing = 0
                tempFlowLayout.minimumInteritemSpacing = 0
                tempFlowLayout.scrollDirection = self.scrollDirection
                return tempFlowLayout
        }()

        lazy var collectionView: UICollectionView = {
                let tempCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
                tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
                tempCollectionView.delegate = self
                tempCollectionView.dataSource = self
                tempCollectionView.showsVerticalScrollIndicator = false
                tempCollectionView.showsHorizontalScrollIndicator = false
                tempCollectionView.isPagingEnabled = true
                return tempCollectionView
        }()
        
        lazy var pageControl: MUPageControl = {
                
                let tempPageControl = MUPageControl(frame: .zero)
                return tempPageControl
        }()
        
        /// private Method
        private func setupTimer()
        {
                let automaticMethod = #selector(automaticScroll)
                let timer: Timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval, target: self, selector: automaticMethod, userInfo: nil, repeats: true)
                self.timer = timer;
                RunLoop.main.add(timer, forMode: .commonModes)
        }
        
        private func invalidateTimer()
        {
                self.timer?.invalidate()
                self.timer = nil;
        }
        /// 当前滚动位置的索引
        private func getCurrentIndex() -> Int
        {
                var index: Int = 0
                if self.scrollDirection == .horizontal {
                
                        index = (Int)(self.collectionView.contentOffset.x / self.flowLayout.itemSize.width + 0.5)
                        
                } else {
                        
                        index = (Int)(self.collectionView.contentOffset.y / self.flowLayout.itemSize.height + 0.5)
                }
                return max(index, 0)
        }
        
        /// 转化为没有放大后的索引
        private func normalIndex(cur: Int) -> Int
        {
                return (cur % dataSource.count)
        }
        
        @objc private func automaticScroll()
        {
                if isOnlyOne() {
                        return;
                }
                
                let curIndex: Int = getCurrentIndex()
                var tarIndex: Int = curIndex + 1;
                
                if tarIndex >= totalItems {
                        if self.infiniteLoop {
                                tarIndex = (Int)(self.totalItems / 2)
                                scrollToItem(index: tarIndex, animated: false)
                                return;
                        }
                }
                scrollToItem(index: tarIndex)
        }
        
        func scrollToItem(index: Int, animated: Bool = true)
        {
                let scrollPosition: UICollectionViewScrollPosition = scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
                self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: scrollPosition, animated: animated)
        }
        
        private func isOnlyOne() -> Bool
        {
                return self.dataSource.count <= 1;
        }
        
        private func setupPageController()
        {
                self.pageControl.removeFromSuperview()
                if showPageControl {
                        
                        if hidesForSinglePage {
                                if self.dataSource.count <= 1 {
                                        self.pageControl.removeFromSuperview()
                                        return;
                                }
                        }
                        self.addSubview(self.pageControl)
                        // 属性设置
                        self.pageControl.currentPageDotColor = curPageDotColor
                        self.pageControl.pageDotColor = pageDotColor
                        self.pageControl.numberOfPages = self.dataSource.count
                        self.pageControl.currentPage = 0
                }
        }
        
        private func contentOffset_dis() -> CGFloat
        {
                if self.scrollDirection == .horizontal {
                        return self.collectionView.contentOffset.x
                } else {
                        return self.collectionView.contentOffset.y
                }
        }
        
        /// 重写初始化方法
        override init(frame: CGRect) {
                super.init(frame: frame)
                initializationUI()
                startTimer()
        }
        
        required init(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)!
                initializationUI()
                startTimer()
        }
        
        override func awakeFromNib() {
                super.awakeFromNib()
                initializationUI()
                startTimer()
        }
        
        /// 布局
        override func layoutSubviews() {
                super.layoutSubviews()
                self.flowLayout.itemSize = self.mu_size
                
                //
                if (contentOffset_dis() == 0 && totalItems > 0) {
                        var targetIndex: Int = 0
                        if self.infiniteLoop {
                                targetIndex = totalItems / 2
                        }
                        scrollToItem(index: targetIndex, animated: false)
                }
                
                //pageControl
                if self.showPageControl {
                        var pageFrame = self.pageControl.frame
                        let minSize: CGSize = self.pageControl.getMinSize(count: self.dataSource.count)
                        pageFrame.origin = self.pageControlAligment.pageLocation(pageSize: minSize, edgeInset: self.pageControlEdgeInsets, size: self.bounds.size)
                        pageFrame.size = minSize
                        self.pageControl.frame = pageFrame
                }
        }
        
        /// 解决当父视图的view释放时，当前视图因为被Timer强引用而不能释放的问题
        override func willMove(toSuperview newSuperview: UIView?) {
                
                if newSuperview == nil {
                        invalidateTimer()
                }
        }
        
        /// 解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
        deinit {
                self.collectionView.delegate = nil;
                self.collectionView.dataSource = nil;
        }
        
        //启动计时器
        func startTimer()
        {
                if self.autoScroll {
                        
                        invalidateTimer()
                        setupTimer()
                }
        }
        
        /// 初始化UI
        func initializationUI() {
                
                self.addSubview(self.collectionView)
                let views = ["collectionView" : self.collectionView] as [String : Any]
                
                //collectionView
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: [], metrics: nil, views: views))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: [], metrics: nil, views: views))
                
                configCollectionView()
        }
        
        ///配置collectionView
        func configCollectionView()
        {
                self.collectionView.scrollsToTop = false
                self.collectionView.backgroundColor = UIColor.white
                self.collectionView.register(MUCycleCell.self, forCellWithReuseIdentifier: cycleReuseIdentifier)
        }
        
        // MARK: - UICollectionViewDelegate & UICollectionViewDataSource
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return totalItems
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cycleCell: MUCycleCell = collectionView.dequeueReusableCell(withReuseIdentifier: cycleReuseIdentifier, for: indexPath) as! MUCycleCell
                
                let norIndex = normalIndex(cur: indexPath.item)
                
                let data = dataSource[norIndex]
                //图片
                cycleCell.imageView.contentMode = bannerImageContentMode
                if data is UIImage {
                        cycleCell.imageView.image = data as? UIImage
                }
                else if data is String {
                        let url: URL? = URL.init(string: data as! String)
//                        if let tempUrl = url {
//                                cycleCell.imageView.kf.setImage(with: ImageResource(downloadURL: tempUrl), placeholder: self.placeHolderImage)
//                        }
                }
                
                //title
                var title: String = ""
                if norIndex < self.titleArray.count {
                        if let tempTitle = self.titleArray[norIndex] {
                                title = tempTitle
                        }
                }
                cycleCell.titleLabel.text = title
                
                //属性设置
                cycleCell.titleLabel.font = titleTextFont
                cycleCell.titleLabel.textColor = titleTextColor
                cycleCell.titleLabel.textAlignment = titleTextAligment
                cycleCell.titleBackView.backgroundColor = titleBackgroundColor
                cycleCell.titleBackView.isHidden = !showTitleLabel
                cycleCell.backViewHeight = titleLabelHeight
                cycleCell.titleEdgeInsets = titleEdgeInsets
                return cycleCell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
                if let tempSelectItem = selectItem {
                        tempSelectItem(normalIndex(cur: indexPath.item))
                }
        }
        
        // MARK: - UIScrollViewDelegate
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
                if self.dataSource.count == 0 {
                        return;
                }
                
                let index: Int = getCurrentIndex();
                self.pageControl.currentPage = normalIndex(cur: index);
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
                if self.autoScroll {
                        invalidateTimer()
                }
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
                
                if self.autoScroll {
                        setupTimer()
                }
        }
}
