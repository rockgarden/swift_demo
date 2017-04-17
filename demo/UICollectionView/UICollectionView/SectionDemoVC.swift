//
//  SectionDemoVC.swift
//  UICollectionView
//

import UIKit

fileprivate let cellReuseIdentifier = "PaperCell"
fileprivate let headerReuseIdentifier = "PaperHeader"
fileprivate let maxW = UIScreen.main.bounds.width - 20

/// EstimatedItemSize & Section Demo
class SectionDemoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    fileprivate var papersDataSource = PapersDataSource()

    // FlowLayout
    lazy fileprivate var flowLayout: UICollectionViewFlowLayout? = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 10
        fl.minimumInteritemSpacing = 0
        fl.scrollDirection = .vertical
        fl.minimumInteritemSpacing = 0
        fl.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        fl.sectionFootersPinToVisibleBounds = false
        fl.headerReferenceSize = CGSize(width: maxW, height: 30)
        /// 启用自适应contentView的内容
        fl.estimatedItemSize = CGSize(width: maxW, height: 120)
        return fl
    }()

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout!)
        cv.register(PaperCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        cv.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.scrollsToTop = false
        cv.backgroundColor = UIColor.lightGray
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 若不用 StoryBoard 中的 View 就不用关闭 automaticallyAdjust
        //automaticallyAdjustsScrollViewInsets = false

        view.addSubview(collectionView)
        let views = ["cv":collectionView] as [String : Any]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[cv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(0)-[cv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map { $0 })

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(self.rightBarBtnItemAction(sender:)))
    }

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //  override func prepareForSegue(segue: UIStoryboardSegue, sender:
    //    AnyObject?) {
    //      if segue.identifier == "MasterToDetail" {
    //        if let indexPath = collectionView!.indexPathsForSelectedItems()!.first {
    //            if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
    //                let detailViewController = segue.destinationViewController as! DetailViewController
    //                detailViewController.paper = paper
    //            }
    //        }
    //      }
    //  }

    fileprivate var cellCanDel = false
    func rightBarBtnItemAction(sender: Any?){
        cellCanDel = !cellCanDel
        for cell in collectionView.visibleCells{
            if cell is PaperCell{
                (cell as! PaperCell).showDel(cellCanDel)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MasterToDetail" {
            let detailViewController = segue.destination as! SectionDemoDetailVC
            detailViewController.paper = sender as? Paper
        }
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return papersDataSource.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(papersDataSource.count)")
        return papersDataSource.numberOfPapersInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! SectionHeaderView

        if let title = papersDataSource.titleForSectionAtIndexPath(indexPath) {
            sectionHeaderView.title = title
        }
        return sectionHeaderView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PaperCell

        /// Cell class delegate
        cell.delegate = self

        /// Configure the cell
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            cell.paper = paper
        }
        cell.showDel(cellCanDel)

        /// 若从网络下载图片,则可在完成后调用
        //collectionView.reloadItems(at: [indexPath])
        return cell
    }

    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        let width = (collectionView.frame.size.width)/3
    //        let height = width*0.5625
    //        return CGSize(width: width, height: height)
    //    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            performSegue(withIdentifier: "MasterToDetail", sender: paper)
        }
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        debugPrint("\(sourceIndexPath) \(destinationIndexPath)")
    }

}

// MARK: Delete Item
extension SectionDemoVC: PaperCellDelegate {
    func deleteActionByCell(cell: PaperCell) {
        if let indexPath = collectionView.indexPath(for: cell){
            collectionView.performBatchUpdates({ [weak self] in
                self?.papersDataSource.deleteItemsAtIndexPaths([indexPath])
                self?.collectionView.deleteItems(at: [indexPath])
                }, completion: { (res: Bool) in
            })
        }
    }
}


// MARK: - Data Source
class PapersDataSource {

    fileprivate var papers: [Paper] = []
    fileprivate var immutablePapers: [Paper] = []
    fileprivate var sections: [String] = []

    var count: Int {
        return papers.count
    }

    var numberOfSections: Int {
        return sections.count
    }

    // MARK: Public

    init() {
        papers = loadPapersFromDisk()
        immutablePapers = papers
    }

    func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
        var indexes: [Int] = []
        for indexPath in indexPaths {
            indexes.append(absoluteIndexForIndexPath(indexPath))
        }
        var newPapers: [Paper] = []
        for (index, paper) in papers.enumerated() {
            if !indexes.contains(index) {
                newPapers.append(paper)
            }
        }
        papers = newPapers
    }

    func indexPathForNewRandomPaper() -> IndexPath {
        let index = Int(arc4random_uniform(UInt32(immutablePapers.count)))
        let paperToCopy = immutablePapers[index]
        let newPaper = Paper(copying: paperToCopy)
        papers.append(newPaper)
        papers.sort { $0.index < $1.index }
        return indexPathForPaper(newPaper)
    }

    func indexPathForPaper(_ paper: Paper) -> IndexPath {
        let section = sections.index(of: paper.section)!
        var item = 0
        for (index, currentPaper) in papersForSection(section).enumerated() {
            if currentPaper === paper {
                item = index
                break
            }
        }
        return IndexPath(item: item, section: section)
    }

    func movePaperAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
        if indexPath == newIndexPath {
            return
        }
        let index = absoluteIndexForIndexPath(indexPath)
        let paper = papers[index]
        paper.section = sections[newIndexPath.section]
        let newIndex = absoluteIndexForIndexPath(newIndexPath)
        papers.remove(at: index)
        papers.insert(paper, at: newIndex)
    }

    func numberOfPapersInSection(_ index: Int) -> Int {
        let papers = papersForSection(index)
        return papers.count
    }

    func paperForItemAtIndexPath(_ indexPath: IndexPath) -> Paper? {
        if indexPath.section > 0 {
            let papers = papersForSection(indexPath.section)
            return papers[indexPath.item]
        } else {
            return papers[indexPath.item]
        }
    }

    func titleForSectionAtIndexPath(_ indexPath: IndexPath) -> String? {
        if indexPath.section < sections.count {
            return sections[indexPath.section]
        }
        return nil
    }

    // MARK: Private
    fileprivate func absoluteIndexForIndexPath(_ indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<indexPath.section {
            index += numberOfPapersInSection(i)
        }
        index += indexPath.item
        return index
    }

    fileprivate func loadPapersFromDisk() -> [Paper] {
        sections.removeAll(keepingCapacity: false)
        if let path = Bundle.main.path(forResource: "Papers", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                var papers: [Paper] = []
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let caption = dict["caption"] as! String
                        let imageName = dict["imageName"] as! String
                        let section = dict["section"] as! String
                        let index = dict["index"] as! Int
                        let paper = Paper(caption: caption, imageName: imageName, section: section, index: index)
                        if !sections.contains(section) {
                            sections.append(section)
                        }
                        papers.append(paper)
                    }
                }
                return papers
            }
        }
        return []
    }

    fileprivate func papersForSection(_ index: Int) -> [Paper] {
        let section = sections[index]
        let papersInSection = papers.filter { (paper: Paper) -> Bool in
            return paper.section == section
        }
        return papersInSection
    }

}


// MARK: - Detail VC
class SectionDemoDetailVC: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!

    var paper: Paper?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let paper = paper {
            navigationItem.title = paper.caption
            imageView.image = UIImage(named: paper.imageName)
        }
    }

}


// MARK: - Model Paper
class Paper {

    var caption: String
    var imageName: String
    var section: String
    var index: Int

    init(caption: String, imageName:String, section: String, index: Int) {
        self.caption = caption
        self.imageName = imageName
        self.section = section
        self.index = index
    }

    convenience init(copying paper: Paper) {
        self.init(caption: paper.caption, imageName: paper.imageName, section: paper.section, index: paper.index)
    }

}


// MARK: - Cell View
protocol PaperCellDelegate: NSObjectProtocol {
    func deleteActionByCell(cell: PaperCell)
}
class PaperCell: UICollectionViewCell {
    /// willSet and didSet observers are not called when a property is first initialized. They are only called when the property’s value is set outside of an initialization context. 也就是说 initialization 时不调用!!! 只有在新的值被设定后立即调用
    /*:
     1，不仅可以在属性值改变后触发didSet，也可以在属性值改变前触发willSet。
     2，给属性添加观察者必须要声明清楚属性类型，否则编译器报错。
     3，willSet可以带一个newName的参数，没有的话，该参数默认命名为newValue。
     4，didSet可以带一个oldName的参数，表示旧的属性，不带的话默认命名为oldValue。
     5，属性初始化时，willSet和didSet不会调用。只有在初始化上下文之外，当设置属性值时才会调用。
     6，即使是设置的值和原来值相同，willSet和didSet也会被调用。
     */
    fileprivate var paperImageView: UIImageView = {
        let v = UIImageView()
        /// 自适应图片宽高比例
        v.contentMode = UIViewContentMode.scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate var gradientView: GradientView = {
        let v = GradientView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate var captionLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    fileprivate var delButton: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("X", for: .normal)
        v.setTitleColor(.blue, for: .normal)
        v.setTitleColor(.lightGray, for: .highlighted)
        v.isHidden = true
        return v
    }()

    var delegate: PaperCellDelegate?

    var paper: Paper? {
        didSet {
            if let paper = paper {
                if let i = UIImage(named: paper.imageName) {
                    if i.size.width > maxW {
                        //i.resizeWithWidth(width: maxW)
                    }
                    paperImageView.image = i
                } else {
                    /// 若是 image = nil 则 调整 paperImageView constraints 从而让 contentView 适应内容, 但会导致 在cell view 复用时布局异常; 所以最优的办法是加载一张图片, 以内容驱动!
                    //debugPrint(captionLabel.constraints)
                    //debugPrint(paperImageView.constraints)
                    //paperImageView.constraints[0].constant = captionLabel.constraints[0].constant
                    //paperImageView.constraints[1].constant = captionLabel.constraints[2].constant
                    let i = UIImage(color: .clear, size: CGSize(width:captionLabel.constraints[0].constant, height: captionLabel.constraints[1].constant))
                    paperImageView.image = i
                }
                captionLabel.text = paper.caption
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Rasterize the cells for performance
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 8
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = UIColor.white

        // FIXME: 不加self无法找到Action
        delButton.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    fileprivate func setupViews() {
        isSelected = false

        contentView.addSubview(paperImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(captionLabel)
        contentView.addSubview(delButton)

        debugPrint(contentView.bounds)

        let views = ["piv":paperImageView, "gv":gradientView, "cl":captionLabel, "db": delButton] as [String : Any]
        let metrics = ["maxW": maxW]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                /// <=maxW 用于限制 item width 过大 contentSize width
                withVisualFormat: "H:|-(0)-[piv(<=maxW)]-(0)-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(0)-[piv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[gv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[gv(20)]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[cl]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[cl(20)]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[db(20)]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(0)-[db(20)]", options: [], metrics: nil, views: views),
            ].joined().map { $0 })
    }

    @objc fileprivate func btnAction(_ sender: Any) {
        delegate?.deleteActionByCell(cell: self)
    }

    /// 由数据驱动 Cell 是否允许删除
    func showDel(_ canDel: Bool){
        if canDel == true {
            // 编辑模式，显示删除
            delButton.isHidden = false
        }else {
            delButton.isHidden = true
        }
    }

    // TODO: 能否解决 复用时 没有 新的 image 造成的图片重复显示？
    override public func prepareForReuse() {
        super.prepareForReuse()
        paperImageView.image = nil
    }
}


// MARK: - Header View
class SectionHeaderView: UICollectionReusableView {

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    fileprivate let titleLabel: UILabel = {
        let v = UILabel()
        v.backgroundColor = .clear
        v.textColor = UIColor.black
        v.textAlignment = .center
        v.lineBreakMode = .byTruncatingTail
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)

        let views = ["tl":titleLabel] as [String : Any]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[tl]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(0)-[tl]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map { $0 })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


// MARK: - GradientView
class GradientView: UIView {

    lazy fileprivate var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor(white: 0.0, alpha: 0.75).cgColor]
        layer.locations = [NSNumber(value: 0.0 as Float), NSNumber(value: 1.0 as Float)]
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.addSublayer(gradientLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}


fileprivate extension UIImage {

    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        //self(cgImage: (image?.cgImage!)!)
    }

    class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func resizeWithWidth(width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    func resizeWithHeight(height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
}
