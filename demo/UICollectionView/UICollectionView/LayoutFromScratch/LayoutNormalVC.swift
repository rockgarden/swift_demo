
import UIKit

class LayoutNormalVC : UICollectionViewController {

    var sectionNames = [String]()
    var sectionData = [[String]]()

    /// load lazily from nib
    lazy var modelCell : Cell = {
        () -> Cell in
        let arr = UINib(nibName:"Cell", bundle:nil).instantiate(withOwner: nil, options:nil)
        return arr[0] as! Cell
    }()

    override func viewDidLoad() {
        prepareData(sectionNames: &sectionNames, cellData: &sectionData)

        self.navigationItem.title = "States"
        let bb = UIBarButtonItem(title:"Push", style:.plain, target:self, action:#selector(doPush))
        self.navigationItem.rightBarButtonItem = bb

        let cv = self.collectionView!

        cv.backgroundColor = UIColor.lightGray
        cv.allowsMultipleSelection = true
        // register cell, comes from a nib even though we are using a storyboard
        cv.register(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier:"Cell")
        // register headers (for the other view controller!)
        cv.register(UICollectionReusableView.self,
                    forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,
                    withReuseIdentifier:"Header")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionData[section].count
    }

    // headers
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", for:indexPath)
            if v.subviews.count == 0 {
                let lab = UILabel() // we will size it later
                v.addSubview(lab)
                lab.textAlignment = .center
                // look nicer
                lab.font = UIFont(name:"Georgia-Bold", size:22)
                lab.backgroundColor = UIColor.lightGray
                lab.layer.cornerRadius = 8
                lab.layer.borderWidth = 2
                lab.layer.masksToBounds = true // has to be added for iOS 8 label
                lab.layer.borderColor = UIColor.black.cgColor
                lab.translatesAutoresizingMaskIntoConstraints = false
                v.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lab(35)]",
                                                   options:[], metrics:nil, views:["lab":lab]))
                v.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat: "V:[lab(30)]-5-|",
                                                   options:[], metrics:nil, views:["lab":lab]))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sectionNames[(indexPath as NSIndexPath).section]
        }
        return v
    }

    // cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        if cell.lab.text == "Label" { // new cell
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            cell.backgroundColor = .gray

            // checkmark in top left corner when selected
            let im = imageOfSize(cell.bounds.size) {
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
                con.scaleBy(x:1.1, y:1)
                check2.draw(at:CGPoint(2,0))
            }
            let iv = UIImageView(image:nil, highlightedImage:im)
            iv.isUserInteractionEnabled = false
            cell.addSubview(iv)
        }

        cell.lab.text = self.sectionData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        var stateName = cell.lab.text!
        // flag in background! very cute
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of: " ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        cell.backgroundView = iv

        return cell
    }

    func doPush(_ sender: Any?) {
        self.performSegue(withIdentifier: "show", sender: self)
    }
}


extension LayoutNormalVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.modelCell.lab.text = self.sectionData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        var sz = self.modelCell.container.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width)
        sz.height = ceil(sz.height)
        return sz
    }
}

