
import UIKit

class LayoutNormalVC : UICollectionViewController {
    
    var sectionNames = [String]()
    var sectionData = [[String]]()
    lazy var modelCell : Cell = { // load lazily from nib
        () -> Cell in
        let arr = UINib(nibName:"Cell", bundle:nil).instantiate(withOwner: nil, options:nil)
        return arr[0] as! Cell
        }()

    override func viewDidLoad() {
        let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!, encoding: .utf8)
        let states = s.components(separatedBy: "\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append( c.uppercased() )
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append( [String]() )
            }
            sectionData[sectionData.count-1].append( aState )
        }
        self.navigationItem.title = "States"
        let bb = UIBarButtonItem(title:"Push", style:.plain, target:self, action:#selector(doPush))
        self.navigationItem.rightBarButtonItem = bb
        self.collectionView!.backgroundColor = UIColor.white
        self.collectionView!.allowsMultipleSelection = true
        
        // register cell, comes from a nib even though we are using a storyboard
        self.collectionView!.register(UINib(nibName:"Cell", bundle:nil), forCellWithReuseIdentifier:"Cell")
        // register headers (for the other view controller!)
        self.collectionView!.register(UICollectionReusableView.self,
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader,
            withReuseIdentifier:"Header")

        // no supplementary views or anything
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
            var im = UIImage()
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:cell.bounds.size)
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
                // Fallback on earlier versions
                UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
                let con = UIGraphicsGetCurrentContext()!
                let shadow = NSShadow()
                shadow.shadowColor = UIColor.darkGray
                shadow.shadowOffset = CGSize(width: 2,height: 2)
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
                check2.draw(at: CGPoint(x: 2,y: 0))
                im = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
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

    func doPush(_ sender:AnyObject?) {
        self.performSegue(withIdentifier: "show", sender: self)
    }

}

extension LayoutNormalVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.modelCell.lab.text = self.sectionData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        var sz = self.modelCell.container.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width); sz.height = ceil(sz.height)
        return sz
    }
}

