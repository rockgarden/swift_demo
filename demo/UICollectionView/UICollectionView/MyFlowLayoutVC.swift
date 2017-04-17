//
//  MyFlowLayoutVC.swift
//  UICollectionView
//

import UIKit

fileprivate extension Array {
    mutating func remove(at ixs:Set<Int>) -> () {
        for i in Array<Int>(ixs).sorted(by:>) {
            self.remove(at:i)
        }
    }
}

class MyFlowLayoutVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var sectionNames = [String]()
    var cellData = [[String]]()
    fileprivate var isEdit: Bool = false {
        didSet {
            collectionView?.reloadData()
        }
    }

    /// load lazily from nib
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
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append(c.uppercased())
                // and in that case also add new subarray to our array of subarrays
                self.cellData.append([String]())
            }
            self.cellData[self.cellData.count-1].append(aState)
        }

        self.navigationItem.title = "States"
        let b = UIBarButtonItem(title:"Switch", style:.plain, target:self, action:#selector(self.doSwitch(_:)))
        let b2 = UIBarButtonItem(title:"Delete", style:.plain, target:self, action:#selector(self.doDelete(_:)))
        let b3 = UIBarButtonItem(title:"Edit", style:.plain, target:self, action:#selector(self.doEdit(_:)))
        self.navigationItem.setRightBarButtonItems([b,b2,b3], animated: true)

        self.collectionView!.backgroundColor = .white
        self.collectionView!.allowsMultipleSelection = true
        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.register(UINib(nibName:"MyFlowLayoutCell", bundle:nil), forCellWithReuseIdentifier:"MyFlowLayoutCell")
        // register headers
        self.collectionView!.register(UICollectionReusableView.self,
                                      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,
                                      withReuseIdentifier:"Header")

        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        self.setUpFlowLayout(flow)

        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(handleLongGesture(gesture:)))
        longPress.minimumPressDuration = 0.30
        collectionView?.addGestureRecognizer(longPress)
    }

    func selectEditButton(sender: UIButton) {
        isEdit = !isEdit
    }

    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if !isEdit {
            return
        }
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView?.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }

    func setUpFlowLayout(_ flow: UICollectionViewFlowLayout) {
        flow.headerReferenceSize = CGSize(50,50) // larger - we will place label within this
        flow.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10) // looks nicer

        // flow.sectionHeadersPinToVisibleBounds = true // try cool new iOS 9 feature

        // uncomment to crash
        // cripes, now we don't crash, but the layout is wrong! can these guys never get this implemented???
        // also tried doing this by overriding sizeThatFits in the cell, but with the same wrong layout
        // also tried doing it by overriding preferredAttributes in the cell, same wrong layout
        if #available(iOS 10.0, *) {
            flow.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        } else {
            flow.estimatedItemSize = CGSize(60,20)
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellData[section].count
    }

    /// Sectionheaders
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

    /// cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MyFlowLayoutCell", for: indexPath) as! MyFlowLayoutCell
        if cell.lab.text == "Label" {
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2

            cell.backgroundColor = .gray
            let im: UIImage!
            let imSize = CGSize(width:cell.bounds.width, height:cell.bounds.height + CGFloat(indexPath.item) * 2)
            // checkmark in top left corner when selected
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:imSize)
                im = r.image {
                    ctx in let con = ctx.cgContext
                    let shadow = NSShadow()
                    shadow.shadowColor = UIColor.darkGray
                    shadow.shadowOffset = CGSize(2,2)
                    shadow.shadowBlurRadius = 4
                    let check2 =
                        NSAttributedString(string:"\u{2714}", attributes:[
                            NSFontAttributeName: UIFont(name:"ZapfDingbatsITC", size:24)!,
                            NSForegroundColorAttributeName: UIColor.green,
                            NSStrokeColorAttributeName: UIColor.red,
                            NSStrokeWidthAttributeName: -4,
                            NSShadowAttributeName: shadow
                            ])
                    con.scaleBy(x:1.1, y:1)
                    check2.draw(at:CGPoint(2,0))
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(imSize, false, 0)
                let con = UIGraphicsGetCurrentContext()!
                let shadow = NSShadow()
                shadow.shadowColor = UIColor.darkGray
                shadow.shadowOffset = CGSize(2,2)
                shadow.shadowBlurRadius = 4
                let check2 =
                    NSAttributedString(string:"\u{2714}", attributes:[
                        NSFontAttributeName: UIFont(name:"ZapfDingbatsITC", size:24)!,
                        NSForegroundColorAttributeName: UIColor.green,
                        NSStrokeColorAttributeName: UIColor.red,
                        NSStrokeWidthAttributeName: -4,
                        NSShadowAttributeName: shadow
                        ])
                con.scaleBy(x: 1.1, y: 1)
                check2.draw(at:CGPoint(2,0))
                im = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }

            let iv = UIImageView(image:nil, highlightedImage:im)
            iv.isUserInteractionEnabled = false
            cell.addSubview(iv)
            debugPrint(iv.bounds)
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

        cell.observeDelete { [weak self] text in
            guard let strongSelf = self else { return }
            deleteData(byText: text)
        }

        /// Delete ttem by reloadData
        func deleteData(byText text: String) {
            cellData = cellData.filter { $0[0] != text }
            collectionView.reloadData()
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MyFlowLayoutCell else {
            return
        }
        if isEdit {
            cell.startEdit()
        } else {
            cell.stopEdit()
        }
    }

    // what's the minimum size each cell can be? its constraints will figure it out for us!

    // NB According to Apple, in iOS 8 I should be able to eliminate this code;
    // simply turning on estimatedItemSize should do it for me (sizing according to constraints)
    // but I have not been able to get that feature to work
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     // note; this approach didn't work on iOS 8...
     // ...until I introduced the "container" view
     // systemLayoutSize works on the container view but not on the cell itself in iOS 8
     // (perhaps because the nib lacks a contentView)
     // Oooh, fixed (6.1)!
     self.modelCell.lab.text = self.cellData[indexPath.section][indexPath.row]
     //the "container" workaround is no longer needed
     //var sz = self.modelCell.container.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
     var sz = self.modelCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
     sz.width = ceil(sz.width); sz.height = ceil(sz.height)
     return sz
     }
     */

    // selection: nothing to do!
    // we get automatic highlighting of whatever can be highlighted (i.e. our UILabel)
    // we get automatic overlay of the selectedBackgroundView

    // MARK: Change layouts - can just change layouts on the fly! with built-in animation!!!
    func doSwitch(_ sender: Any!) { // button
        // new iOS 7 property collectionView.collectionViewLayout points to *original* layout, which is preserved
        let oldLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        var newLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        if newLayout == oldLayout {
            newLayout = MyFlowLayoutPrivate()
        }
        self.setUpFlowLayout(newLayout)
        self.collectionView!.setCollectionViewLayout(newLayout, animated:true)
    }

    func doEdit(_ sender: Any) {
        isEdit = !isEdit
    }

    // MARK: Deletion - really quite similar to a table view
    func doDelete(_ sender: Any) { // button, delete selected cells
        guard var items = self.collectionView!.indexPathsForSelectedItems,
            items.count > 0 else {return}
        // sort
        items.sort()
        // delete data
        var empties : Set<Int> = [] // keep track of what sections get emptied
        for item in items.reversed() {
            self.cellData[item.section].remove(at:item.item)
            if self.cellData[item.section].count == 0 {
                empties.insert(item.section)
            }
        }
        // request the deletion from the view; notice the slick automatic animation
        self.collectionView!.performBatchUpdates({
            self.collectionView!.deleteItems(at:items)
            if empties.count > 0 { // delete empty sections
                self.sectionNames.remove(at:empties)
                self.cellData.remove(at:empties)
                self.collectionView!.deleteSections(IndexSet(empties)) // Set turns directly into IndexSet!
            }
        })
    }

    /// Menu 与 Drag 是系统自带的事件, 但相互屏蔽
    // MARK: Menu - exactly as for table views
    @nonobjc private let capital = #selector(MyFlowLayoutCell.capital)
    @nonobjc private let copy = #selector(UIResponderStandardEditActions.copy)

    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        let mi = UIMenuItem(title:"Capital", action:capital)
        UIMenuController.shared.menuItems = [mi]
        return false //uncomment to do dragging; you can't have both menus and dragging (because they both use the long press gesture, I presume)
        //return true
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

    // MARK: Dragging
    /// on by default; data source merely has to permit -------- interactive moving, data source methods
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


class MyFlowLayoutPrivate: UICollectionViewFlowLayout {
    // how to left-justify every "line" of the layout
    // looks much nicer, in my humble opinion

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)!

        var lastXOffset: CGFloat = 0
        var lastYCenter: CGFloat = 0
        for attr in attrs {
            if attr.center.y != lastYCenter {
                lastYCenter = attr.center.y
                lastXOffset = 0
            }
            attr.frame.origin.x = lastXOffset
            lastXOffset = attr.frame.origin.x + attr.frame.size.width + minimumInteritemSpacing
        }

        return attrs.map {
            attr in // remove (var atts)
            var atts = attr
            if atts.representedElementCategory == .cell {
                let ip = atts.indexPath
                atts = self.layoutAttributesForItem(at:ip)!
            }
            return atts
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForItem(at:indexPath)!
        if indexPath.item == 0 {
            return atts // degenerate case 1
        }
        if atts.frame.origin.x - 1 <= self.sectionInset.left {
            return atts // degenerate case 2
        }
        let ipPv = IndexPath(item:indexPath.row-1, section:indexPath.section)
        let fPv = self.layoutAttributesForItem(at:ipPv)!.frame
        let rightPv = fPv.origin.x + fPv.size.width + self.minimumInteritemSpacing
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.x = rightPv
        return atts
    }
    
}


class MyFlowLayoutCell: UICollectionViewCell {

    @IBOutlet var lab: UILabel!
    @IBOutlet var container: UIView!

    private let deleteButton = UIButton(type: .contactAdd)
    private var deleteClosure: ((String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = UIColor.blue.cgColor

        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(self.deleteText), for: .touchUpInside)
        contentView.addSubview(deleteButton)
    }

    func capital(_ sender: Any!) {
        // find my collection view
        var v : UIView = self
        repeat { v = v.superview! } while !(v is UICollectionView)
        let cv = v as! UICollectionView
        // ask it what index path we are
        let ip = cv.indexPath(for: self)!
        // relay to its delegate
        cv.delegate?.collectionView?(cv, performAction:#selector(capital), forItemAt: ip, withSender: sender)
    }

    func deleteText() {
        deleteClosure?(lab.text!)
    }

    func observeDelete(closure: @escaping (String) -> ()) {
        deleteClosure = closure
    }

    func startEdit() {
        deleteButton.isHidden = false
        startShake()
    }

    func stopEdit() {
        deleteButton.isHidden = true
        stopShake()
    }

    private func startShake() {
        let animation =  CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [2 / self.frame.width, -2 / self.frame.width]
        animation.duration = 0.3
        animation.isAdditive = true
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        self.layer.add(animation, forKey: "shake")
    }

    private func stopShake() {
        self.layer.removeAnimation(forKey: "shake")
    }

    /*
     override func sizeThatFits(_ size: CGSize) -> CGSize {
     var sz = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
     sz.width = ceil(sz.width); sz.height = ceil(sz.height)
     return sz
     }
     */

    /*
     override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
     setNeedsLayout()
     layoutIfNeeded()
     let sz = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
     //sz.width = ceil(sz.width); sz.height = ceil(sz.height)
     let atts = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
     atts.size = sz
     //var newFrame = layoutAttributes.frame
     //newFrame.size.height = sz.height
     //newFrame.size.width = sz.width
     //layoutAttributes.frame = newFrame
     return atts
     }
     */
    
    
}
