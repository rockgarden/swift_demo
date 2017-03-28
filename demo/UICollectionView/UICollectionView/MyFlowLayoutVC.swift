//
//  MyFlowLayoutVC.swift
//  UICollectionView
//

import UIKit

extension Array {
    mutating func remove(at ixs:Set<Int>) -> () {
        for i in Array<Int>(ixs).sorted(by:>) {
            self.remove(at:i)
        }
    }
}

class MyFlowLayoutVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var sectionNames = [String]()
    var cellData = [[String]]()
    lazy var modelCell : MyFlowLayoutCell = { // load lazily from nib
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
        let b = UIBarButtonItem(title:"Switch", style:.plain, target:self, action:#selector(doSwitch(_:)))
        let b2 = UIBarButtonItem(title:"Delete", style:.plain, target:self, action:#selector(doDelete(_:)))
        self.navigationItem.setRightBarButtonItems([b,b2], animated: true)
        
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
        
        return cell
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
    
    // =======================
    
    // can just change layouts on the fly! with built-in animation!!!
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
    
    // =======================
    
    // deletion, really quite similar to a table view
    
    @IBAction func doDelete(_ sender: Any) { // button, delete selected cells
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
        // request the deletion from the view; notice the slick automatic animation
        self.collectionView!.performBatchUpdates({
            self.collectionView!.deleteItems(at:arr)
            if empties.count > 0 { // delete empty sections
                self.sectionNames.remove(at:empties) // see utility function at top of file
                self.cellData.remove(at:empties)
                self.collectionView!.deleteSections(IndexSet(empties)) // Set turns directly into IndexSet!
            }
        })
    }
    
    // menu =================
    
    // exactly as for table views
    
    @nonobjc private let capital = #selector(MyFlowLayoutCell.capital)
    @nonobjc private let copy = #selector(UIResponderStandardEditActions.copy)
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        let mi = UIMenuItem(title:"Capital", action:capital)
        UIMenuController.shared.menuItems = [mi]
        // return false // uncomment to do dragging; you can't have both menus and dragging
        // (because they both use the long press gesture, I presume)
        return true
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
    
    // dragging ===============
    // on by default; data source merely has to permit
    // -------- interactive moving, data source methods
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ cv: UICollectionView, moveItemAt source: IndexPath, to dest: IndexPath) {
        // rearrange model
        swap(&self.cellData[source.section][source.item], &self.cellData[dest.section][dest.item])
        // reload
        cv.reloadSections(IndexSet(integer:source.section))
    }
    
    // modify using delegate methods
    // here, prevent moving outside your own section
    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt orig: IndexPath, toProposedIndexPath prop: IndexPath) -> IndexPath {
        if orig.section != prop.section {
            return orig
        }
        return prop
    }
}


class MyFlowLayoutPrivate : UICollectionViewFlowLayout {
    // how to left-justify every "line" of the layout
    // looks much nicer, in my humble opinion
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr = super.layoutAttributesForElements(in: rect)!
        return arr.map {
            atts in // remove (var atts)
            var atts = atts
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

