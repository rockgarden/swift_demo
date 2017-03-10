//
//  CycleScrollView.swift
//

import UIKit
//import Kingfisher

public enum PageControlStyle {
    case none
    case system
    case fill
    case pill
    case snake
}

public enum PageControlPosition {
    case center
    case left
    case right
}

typealias didSelectItemClosure_SCV = (NSInteger) -> Void

@IBDesignable open class CycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    // MARK: 控制参数
    // 是否自动滚动，默认true
    @IBInspectable open var autoScroll: Bool? = true {
        didSet {
            invalidateTimer()
            if autoScroll! {
                setupTimer()
            }
        }
    }
    
    // 无限循环，默认true 此属性修改了就不存在轮播的意义了
    @IBInspectable open var infiniteLoop: Bool? = true {
        didSet {
            if imagePaths.count > 0 {
                let temp = imagePaths
                imagePaths = temp
            }
        }
    }
    
    /// 滚动方向，默认horizontal
    fileprivate var _scrollPosition: UICollectionViewScrollPosition! = .centeredHorizontally
    open var scrollDirection: UICollectionViewScrollDirection? = .horizontal {
        didSet {
            flowLayout?.scrollDirection = scrollDirection!
            if scrollDirection == .horizontal {
                _scrollPosition = .centeredHorizontally
            }else{
                _scrollPosition = .centeredVertically
            }
        }
    }
    
    // 滚动间隔时间,默认2s
    @IBInspectable open var autoScrollTimeInterval: Double = 3.0 {
        didSet {
            autoScroll = true
        }
    }
    
    // 加载状态图 -- 这个是有数据，等待加载的占位图
    @IBInspectable open var placeHolderImage: UIImage? = nil {
        didSet {
            if placeHolderImage != nil {
                placeHolderViewImage = placeHolderImage
            }
        }
    }
    
    // 空数据页面显示占位图 -- 这个是没有数据，整个轮播器的占位图
    @IBInspectable open var coverImage: UIImage? = nil {
        didSet {
            if coverImage != nil {
                coverViewImage = coverImage
            }
        }
    }
    
    // 图片显示Mode
    open var imageViewContentMode: UIViewContentMode? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // PageControlStyle
    // MARK: PageControl
    open var pageControlTintColor: UIColor = UIColor.lightGray {
        didSet {
            setupPageControl()
        }
    }
    // 当前显示颜色
    open var pageControlCurrentPageColor: UIColor = UIColor.white {
        didSet {
            setupPageControl()
        }
    }
    
    // MARK: CustomPageControl
    // 注意： 由于属性较多，所以请使用style对应的属性，如果没有标明则通用
    open var customPageControlStyle: PageControlStyle = .system {
        didSet {
            setupPageControl()
        }
    }
    // 颜色
    open var customPageControlTintColor: UIColor = UIColor.white {
        didSet {
            setupPageControl()
        }
    }
    // 间距
    open var customPageControlIndicatorPadding: CGFloat = 8 {
        didSet {
            setupPageControl()
        }
    }
    
    // PageControl 位置 （此属性目前仅支持系统默认控制器，未来会支持其他自定义PageControl）
    open var pageControlPosition: PageControlPosition = .center {
        didSet {
            setupPageControl()
        }
    }
    
    open var pageControlLeadingOrTrialingContact: CGFloat = 28 {
        didSet {
            setupPageControl()
        }
    }
    
    // PageControlStyle == .fill
    // 圆大小
    open var FillPageControlIndicatorRadius: CGFloat = 4 {
        didSet {
            setupPageControl()
        }
    }
    
    // PageControlStyle == .pill || PageControlStyle == .snake
    // 当前的颜色
    open var customPageControlInActiveTintColor: UIColor = UIColor(white: 1, alpha: 0.3) {
        didSet {
            setupPageControl()
        }
    }
    
    // 背景色
    @IBInspectable open var collectionViewBackgroundColor: UIColor! = UIColor.clear
    
    // ImagePaths
    open var imagePaths: [String] = [] {
        didSet {
            totalItemsCount = infiniteLoop! ? imagePaths.count * 100 : imagePaths.count
            if imagePaths.count != 1 {
                collectionView.isScrollEnabled = true
                autoScroll = true
            }else{
                collectionView.isScrollEnabled = false
            }
            setupPageControl()
            collectionView.reloadData()
        }
    }
    
    // 标题
    open var titles: Array<String> = []
    
    // MARK: Private
    // Identifier
    fileprivate let identifier = "LLCycleScrollViewCell"
    
    // 数量
    fileprivate var totalItemsCount: NSInteger! = 1
    
    // 显示图片(CollectionView)
    lazy var collectionView: UICollectionView = {
        let tempCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout!)
        tempCollectionView.register(CycleScrollViewCell.self, forCellWithReuseIdentifier: self.identifier)
        tempCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.showsVerticalScrollIndicator = false
        tempCollectionView.showsHorizontalScrollIndicator = false
        tempCollectionView.isPagingEnabled = true
        tempCollectionView.scrollsToTop = false
        tempCollectionView.backgroundColor = self.collectionViewBackgroundColor
        return tempCollectionView
    }()
    
    // FlowLayout
    lazy fileprivate var flowLayout: UICollectionViewFlowLayout? = {
        let tempFlowLayout = UICollectionViewFlowLayout()
        tempFlowLayout.minimumLineSpacing = 0
        tempFlowLayout.minimumInteritemSpacing = 0
        tempFlowLayout.scrollDirection = .horizontal
        return tempFlowLayout
    }()

    // 计时器
    fileprivate var timer: Timer?

    // PageControl
    open var pageControl: UIPageControl?
    
    open var customPageControl: UIView?
    
    // 加载状态图
    fileprivate var placeHolderViewImage = UIImage.init(named: "CycleScrollView.bundle/llplaceholder.png")
    
    // 空数据页面显示占位图
    fileprivate var coverViewImage = UIImage.init(named: "CycleScrollView.bundle/llplaceholder.png")
    
    // 回调
    var didSelectItemClosure: didSelectItemClosure_SCV?
    
    // MARK: Init
    convenience init(didSelectItemAtIndex: didSelectItemClosure_SCV? = nil) {
        self.init()
        if didSelectItemAtIndex != nil {
            didSelectItemClosure = didSelectItemAtIndex
        }
        initialize()
    }

    /// 适配 NSLayoutConstraint
    fileprivate func initialize() {
        addSubview(collectionView)
        let views = ["cv" : collectionView] as [String : Any]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cv]-0-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cv]-0-|", options: [], metrics: nil, views: views))
    }
    
    // MARK: Timer
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval as TimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    func invalidateTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func setupPageControl() {
        // 重新添加
        if pageControl != nil {
            pageControl?.removeFromSuperview()
        }
        if customPageControl != nil {
            customPageControl?.removeFromSuperview()
        }
        
        if customPageControlStyle == .none {
            pageControl = UIPageControl.init()
            pageControl?.numberOfPages = self.imagePaths.count
        }
        
        if customPageControlStyle == .system {
            pageControl = UIPageControl.init()
            pageControl?.pageIndicatorTintColor = pageControlTintColor
            pageControl?.currentPageIndicatorTintColor = pageControlCurrentPageColor
            pageControl?.numberOfPages = self.imagePaths.count
            self.addSubview(pageControl!)
            pageControl?.isHidden = false
        }
        
        if customPageControlStyle == .fill {
            customPageControl = FilledPageControl.init(frame: CGRect.zero)
            customPageControl?.tintColor = customPageControlTintColor
            (customPageControl as! FilledPageControl).indicatorPadding = customPageControlIndicatorPadding
            (customPageControl as! FilledPageControl).indicatorRadius = FillPageControlIndicatorRadius
            (customPageControl as! FilledPageControl).pageCount = self.imagePaths.count
            self.addSubview(customPageControl!)
        }
        
        if customPageControlStyle == .pill {
            customPageControl = PillPageControl.init(frame: CGRect.zero)
            (customPageControl as! PillPageControl).indicatorPadding = customPageControlIndicatorPadding
            (customPageControl as! PillPageControl).activeTint = customPageControlTintColor
            (customPageControl as! PillPageControl).inactiveTint = customPageControlInActiveTintColor
            (customPageControl as! PillPageControl).pageCount = self.imagePaths.count
            self.addSubview(customPageControl!)
        }
        
        if customPageControlStyle == .snake {
            customPageControl = SnakePageControl.init(frame: CGRect.zero)
            (customPageControl as! SnakePageControl).activeTint = customPageControlTintColor
            (customPageControl as! SnakePageControl).indicatorPadding = customPageControlIndicatorPadding
            (customPageControl as! SnakePageControl).indicatorRadius = FillPageControlIndicatorRadius
            (customPageControl as! SnakePageControl).inactiveTint = customPageControlInActiveTintColor
            (customPageControl as! SnakePageControl).pageCount = self.imagePaths.count
            self.addSubview(customPageControl!)
        }
    }
    
    // MARK: layoutSubviews
    override open func layoutSubviews() {
        super.layoutSubviews()
        // Cell Size
        flowLayout?.itemSize = self.frame.size
        // Page Frame
        if customPageControlStyle == .none || customPageControlStyle == .system {
            if pageControlPosition == .center {
                pageControl?.frame = CGRect.init(x: 0, y: self.ll_h-11, width: UIScreen.main.bounds.width, height: 10)
            }else{
                let pointSize = pageControl?.size(forNumberOfPages: self.imagePaths.count)
                if pageControlPosition == .left {
                    pageControl?.frame = CGRect.init(x: -(UIScreen.main.bounds.width - (pointSize?.width)! - pageControlLeadingOrTrialingContact) * 0.5, y: self.ll_h-11, width: UIScreen.main.bounds.width, height: 10)
                }else{
                    pageControl?.frame = CGRect.init(x: (UIScreen.main.bounds.width - (pointSize?.width)! - pageControlLeadingOrTrialingContact) * 0.5, y: self.ll_h-11, width: UIScreen.main.bounds.width, height: 10)
                }
            }
        }else{
            var y = self.ll_h-10-1
            // pill
            if customPageControlStyle == .pill {
                y+=5
            }
            let oldFrame = customPageControl?.frame
            customPageControl?.frame = CGRect.init(x: (oldFrame?.origin.x)!, y: y, width: (oldFrame?.size.width)!, height: 10)
        }
        
        if collectionView.contentOffset.x == 0 && totalItemsCount > 0 {
            var targetIndex = 0
            if infiniteLoop! {
                targetIndex = totalItemsCount/2
            }
            collectionView.scrollToItem(at: IndexPath.init(item: targetIndex, section: 0), at: _scrollPosition, animated: false)
        }
    }
    
    // MARK: Actions
    func automaticScroll() {
        if totalItemsCount == 0 {return}
        let targetIndex = currentIndex() + 1
        scollToIndex(targetIndex: targetIndex)
    }
    
    func scollToIndex(targetIndex: Int) {
        if targetIndex >= totalItemsCount {
            if infiniteLoop! {
                collectionView.scrollToItem(at: IndexPath.init(item: Int(totalItemsCount/2), section: 0), at: _scrollPosition, animated: false)
            }
            return
        }
        collectionView.scrollToItem(at: IndexPath.init(item: targetIndex, section: 0), at: _scrollPosition, animated: true)
    }
    
    func currentIndex() -> NSInteger {
        if collectionView.ll_w == 0 || collectionView.ll_h == 0 {
            return 0
        }
        var index = 0
        if flowLayout?.scrollDirection == UICollectionViewScrollDirection.horizontal {
            index = NSInteger(collectionView.contentOffset.x + (flowLayout?.itemSize.width)! * 0.5)/NSInteger((flowLayout?.itemSize.width)!)
        }else {
            index = NSInteger(collectionView.contentOffset.y + (flowLayout?.itemSize.height)! * 0.5)/NSInteger((flowLayout?.itemSize.height)!)
        }
        return index
    }
    
    func pageControlIndexWithCurrentCellIndex(index: NSInteger) -> (Int) {
        return Int(index % imagePaths.count)
    }
    
    
    // MARK: UICollectionViewDataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CycleScrollViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CycleScrollViewCell
        
        // 0==count 占位图
        if imagePaths.count == 0 {
            cell.imageView.image = coverViewImage
        }else{
            let itemIndex = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
            let imagePath = imagePaths[itemIndex]
            // Mode
            if let imageViewContentMode = imageViewContentMode {
                cell.imageView.contentMode = imageViewContentMode
            }
            
            // 根据imagePath，来判断是网络图片还是本地图
            if imagePath.hasPrefix("http") {
                //cell.imageView.kf.setImage(with: URL(string: imagePath), placeholder: placeHolderImage)
            }else{
                if let image = UIImage.init(named: imagePath) {
                    cell.imageView.image = image;
                }else{
                    cell.imageView.image = UIImage.init(contentsOfFile: imagePath)
                }
            }
            
            // 对冲数据判断
            if itemIndex <= titles.count-1 {
                cell.title = titles[itemIndex]
            }else{
                cell.title = ""
            }
        }
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let didSelectItemAtIndexPath = didSelectItemClosure {
            while imagePaths.count > 0 {
                didSelectItemAtIndexPath(pageControlIndexWithCurrentCellIndex(index: indexPath.item))
            }
        }
    }
    
    // MARK: UIScrollViewDelegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imagePaths.count == 0 { return }
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: currentIndex())
        if customPageControlStyle == .none || customPageControlStyle == .system {
            pageControl?.currentPage = indexOnPageControl
        }else{
            var progress: CGFloat = 999
            // 方向
            if scrollDirection == .horizontal {
                var currentOffsetX = scrollView.contentOffset.x - (CGFloat(totalItemsCount) * scrollView.frame.size.width) / 2
                if currentOffsetX < 0 {
                    currentOffsetX = -currentOffsetX
                }
                if currentOffsetX >= CGFloat(self.imagePaths.count) * scrollView.frame.size.width && infiniteLoop!{
                    collectionView.scrollToItem(at: IndexPath.init(item: Int(totalItemsCount/2), section: 0), at: _scrollPosition, animated: false)
                }
                progress = currentOffsetX / scrollView.frame.size.width
            }else if scrollDirection == .vertical{
                var currentOffsetY = scrollView.contentOffset.y - (CGFloat(totalItemsCount) * scrollView.frame.size.height) / 2
                if currentOffsetY < 0 {
                    currentOffsetY = -currentOffsetY
                }
                if currentOffsetY >= CGFloat(self.imagePaths.count) * scrollView.frame.size.height && infiniteLoop!{
                    collectionView.scrollToItem(at: IndexPath.init(item: Int(totalItemsCount/2), section: 0), at: _scrollPosition, animated: false)
                }
                progress = currentOffsetY / scrollView.frame.size.height
            }
            
            if progress == 999 {
                progress = CGFloat(indexOnPageControl)
            }
            // progress
            if customPageControlStyle == .fill {
                (customPageControl as! FilledPageControl).progress = progress
            }else if customPageControlStyle == .pill {
                (customPageControl as! PillPageControl).progress = progress
            }else if customPageControlStyle == .snake {
                (customPageControl as! SnakePageControl).progress = progress
            }
        }
        
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoScroll! {
            invalidateTimer()
        }
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll! {
            setupTimer()
        }
    }
 
}
