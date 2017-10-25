//
//  DecorationViewVC.swift
//  UICollectionView
//

import UIKit

class DecorationViewVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var sectionNames = [String]()
    var cellData = [[String]]()

    lazy var modelCell : MyFlowLayoutCell = {
        () -> MyFlowLayoutCell in
        let arr = UINib(nibName:"MyFlowLayoutCell", bundle:nil).instantiate(withOwner:nil)
        return arr[0] as! MyFlowLayoutCell
    }()

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        var previous = ""
        for aState in states {
            let c = String(aState.characters.prefix(1))
            if c != previous {
                previous = c
                self.sectionNames.append(c.uppercased())
                self.cellData.append([String]())
            }
            self.cellData[self.cellData.count-1].append(aState)
        }

        let a = UIBarButtonItem(title:"Switch", style:.plain, target:self, action:#selector(doSwitch(_:)))
        let b = UIBarButtonItem(title:"Delete", style:.plain, target:self, action:#selector(doDelete(_:)))
        let c = UIBarButtonItem(title:"Drag", style:.plain, target:self, action:#selector(doDrag(_:)))

        self.navigationItem.setRightBarButtonItems([a,b,c], animated: true)

        self.collectionView!.backgroundColor = .white
        self.collectionView!.allowsMultipleSelection = true

        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.register(UINib(nibName:"MyFlowLayoutCell", bundle:nil), forCellWithReuseIdentifier:"MyFlowLayoutCell")
        // register headers
        self.collectionView!.register(UICollectionReusableView.self,
                                      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,
                                      withReuseIdentifier:"Header")

        self.navigationItem.title = "States"

        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        self.setUpFlowLayout(flow)

    }

    func setUpFlowLayout(_ flow: UICollectionViewFlowLayout) {
        /// 必须设置 header 大小
        flow.headerReferenceSize = CGSize(50,50)
        flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10) // looks nicer
        flow.sectionHeadersPinToVisibleBounds = true // try cool new iOS 9 feature
        (flow as? DecorationViewFlowLayout)?.title = "States"

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellData[section].count
    }

    // headers

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", for: indexPath)
            if v.subviews.count == 0 {
                let lab = UILabel() // we will size it later
                v.addSubview(lab)
                lab.textAlignment = .center
                // look nicer
                lab.font = UIFont(name:"Georgia-Bold", size:22)
                lab.backgroundColor = .lightGray
                lab.layer.cornerRadius = 8
                lab.layer.borderWidth = 2
                lab.layer.masksToBounds = true // has to be added for iOS 8 label
                lab.layer.borderColor = UIColor.black.cgColor
                lab.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    NSLayoutConstraint.constraints(withVisualFormat:"H:|-10-[lab(35)]",
                                                   metrics:nil, views:["lab":lab]),
                    NSLayoutConstraint.constraints(withVisualFormat:"V:[lab(30)]-5-|",
                                                   metrics:nil, views:["lab":lab])
                    ].flatMap{$0})
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sectionNames[indexPath.section]
        }
        return v
    }

    // cells

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MyFlowLayoutCell", for: indexPath) as! MyFlowLayoutCell
        if cell.lab.text == "Label" { // new cell
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2

            cell.backgroundColor = .gray

            let im = imageOfSize(cell.bounds.size) {
                let con = UIGraphicsGetCurrentContext()!
                let shadow = NSShadow()
                shadow.shadowColor = UIColor.darkGray
                shadow.shadowOffset = CGSize(2,2)
                shadow.shadowBlurRadius = 4
                let check2 =
                    NSAttributedString(string:"\u{2714}", attributes:[
                        NSAttributedStringKey.font: UIFont(name:"ZapfDingbatsITC", size:24)!,
                        NSAttributedStringKey.foregroundColor: UIColor.green,
                        NSAttributedStringKey.strokeColor: UIColor.red,
                        NSAttributedStringKey.strokeWidth: -4,
                        NSAttributedStringKey.shadow: shadow
                        ])
                con.scaleBy(x:1.1, y:1)
                check2.draw(at:CGPoint(2,0))
            }

            let iv = UIImageView(image:nil, highlightedImage:im)
            iv.isUserInteractionEnabled = false
            cell.addSubview(iv)
        }
        cell.lab.text = self.cellData[indexPath.section][indexPath.row]
        var stateName = cell.lab.text!
        // flag in background! very cute
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        cell.backgroundView = iv

        return cell
    }

    /// > iOS 8 启用 estimatedItemSize 根据约束调整大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.modelCell.lab.text = self.cellData[indexPath.section][indexPath.row]
        //the "container" workaround is no longer needed
        //var sz = self.modelCell.container.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        var sz = self.modelCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width)
        sz.height = ceil(sz.height)
        return sz
    }

    // Switch =======================

    // MARK: Change layouts - can just change layouts on the fly! with built-in animation!!!
    @objc func doSwitch(_ sender: Any!) {
        // 新的iOS 7属性collectionView.collectionViewLayout指向原始布局
        let oldLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        var newLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        if newLayout == oldLayout {
            newLayout = DecorationViewFlowLayout()
        }
        self.setUpFlowLayout(newLayout)
        self.collectionView!.setCollectionViewLayout(newLayout, animated:true)
    }


    // Delete =======================

    // MARK: Deletion - really quite similar to a table view
    /// delete selected cells
    @objc func doDelete(_ sender: Any) {
        guard var arr = self.collectionView!.indexPathsForSelectedItems,
            arr.count > 0 else {return}
        // sort
        arr.sort()
        // delete data
        var empties : Set<Int> = [] // keep track of what sections get emptied
        for ip in arr.reversed() {
            self.cellData[ip.section].remove(at:ip.item)
            if self.cellData[ip.section].count == 0 {
                empties.insert(ip.section)
            }
        }
        // 从视图中请求删除 request the deletion from the view; notice the slick automatic animation
        self.collectionView!.performBatchUpdates({
            self.collectionView!.deleteItems(at:arr)
            if empties.count > 0 { //delete empty sections
                self.sectionNames.remove(at: empties)
                self.cellData.remove(at: empties)
                self.collectionView!.deleteSections(IndexSet(empties))
            }
        })
    }

    // Menu =================
    // Menu 与 Drag 是系统自带的事件, 但相互屏蔽
    // MARK: Menu - exactly as for table views

    @nonobjc private let capital = #selector(MyFlowLayoutCell.capital)
    @nonobjc private let copy = #selector(UIResponderStandardEditActions.copy)

    var isDrag = false
    @objc func doDrag(_ sender: Any!) {
        isDrag = !isDrag
        self.collectionView!.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        let mi = UIMenuItem(title:"Capital", action:capital)
        UIMenuController.shared.menuItems = [mi]
        /// false 执行拖动，true 显示菜单; 不能同时使用这菜单和拖动
        return isDrag
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return (action == copy) || (action == capital)
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        // in real life, would do something here
        let state = self.cellData[indexPath.section][indexPath.row]
        if action == copy {
            print ("copying \(state)")
        }
        else if action == capital {
            print ("fetching the capital of \(state)")
        }
    }

    // Dragging ===============

    // MARK: Dragging -  data source merely has to permit interactive moving, data source methods
    /// 数据源只需要允许交互式移动
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ cv: UICollectionView, moveItemAt source: IndexPath, to dest: IndexPath) {
        // rearrange model
        swap(&self.cellData[source.section][source.item], &self.cellData[dest.section][dest.item])
        // reload
        cv.reloadSections(IndexSet(integer:source.section))
    }

    /// modify using delegate methods
    /// 禁止段间移动 here, prevent moving outside your own section
    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt orig: IndexPath, toProposedIndexPath prop: IndexPath) -> IndexPath {
        if orig.section != prop.section {
            return orig
        }
        return prop
    }

}

// example of a decoration view

class MyTitleView : UICollectionReusableView {
    weak var lab : UILabel!
    override init(frame: CGRect) {
        super.init(frame:frame)
        let lab = UILabel(frame:self.bounds)
        self.addSubview(lab)
        lab.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lab.font = UIFont(name: "GillSans-Bold", size: 40)
        self.lab = lab
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func apply(_ atts: UICollectionViewLayoutAttributes) {
        if let atts = atts as? MyTitleViewLayoutAttributes {
            self.lab.text = atts.title
        }
    }
}


class MyTitleViewLayoutAttributes : UICollectionViewLayoutAttributes {
    var title = ""
}


class DecorationViewFlowLayout: UICollectionViewFlowLayout {

    private let titleKind = "title"
    private let titleHeight : CGFloat = 50
    private var titleRect : CGRect {
        return CGRect(10,0,200,self.titleHeight)
    }
    var title = "" //this is public API, client should set

    override init() {
        super.init()
        self.register(MyTitleView.self, forDecorationViewOfKind:self.titleKind)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var collectionViewContentSize: CGSize {
        var sz = super.collectionViewContentSize
        sz.height += self.titleHeight
        return sz
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arr = super.layoutAttributesForElements(in: rect)!
        arr = arr.map {
            atts -> UICollectionViewLayoutAttributes in
            var atts = atts
            switch atts.representedElementCategory {
            case .cell:
                let ip = atts.indexPath
                atts = layoutAttributesForItem(at:ip)!
            case .supplementaryView:
                let ip = atts.indexPath
                let kind = atts.representedElementKind!
                atts = layoutAttributesForSupplementaryView(ofKind: kind, at: ip)!
            default: break
            }
            return atts
        }
        // 包括装饰视图的属性 include attributes for decoration view
        if let decatts = self.layoutAttributesForDecorationView(
            ofKind: self.titleKind, at: IndexPath(item: 0, section: 0)) {
            if rect.contains(decatts.frame) {
                arr.append(decatts)
            }
        }
        return arr
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForItem(at:indexPath)!
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.y += self.titleHeight
        if indexPath.item == 0 {
            return atts // degenerate case 1
        }
        if atts.frame.origin.x - 1 <= self.sectionInset.left {
            return atts // degenerate case 2
        }
        let ipPv = IndexPath(item:indexPath.row-1, section:indexPath.section)
        let fPv = self.layoutAttributesForItem(at:ipPv)!.frame
        let rightPv = fPv.origin.x + fPv.size.width + self.minimumInteritemSpacing
        atts.frame.origin.x = rightPv
        return atts
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)!
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.y += self.titleHeight
        return atts
    }

    // TODO: this is where the action is
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == self.titleKind {
            // how to create layout attributes
            let atts = MyTitleViewLayoutAttributes(forDecorationViewOfKind:self.titleKind, with:indexPath)
            // use attributes subclass to communicate instance variable to decoration view
            atts.title = self.title
            atts.frame = self.titleRect
            return atts
        }
        return nil
    }
    
}

