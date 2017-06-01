

import UIKit

fileprivate class MaskView : UIView {
    let rad : CGFloat
    init(frame:CGRect, roundingCorners rad : CGFloat) {
        self.rad = rad
        super.init(frame:frame)
        self.layer.needsDisplayOnBoundsChange = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ r: CGRect) {
        print("drawing")
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(
            UIColor(white:0, alpha:0).cgColor)
        con.fill(r)
        con.setFillColor(
            UIColor(white:0, alpha:1).cgColor)
        let p = UIBezierPath(roundedRect:r, cornerRadius:rad)
        p.fill()
    }
}


class MaskUtilityViewVC: UIViewController {

    lazy var iv : UIImageView = {
        let iv = UIImageView(image: UIImage(named:"Swift"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let which = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(iv)
        addConstraint()
    }

    fileprivate func addConstraint() {
        let views = ["iv":iv]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(50)-[iv]-(50)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(200)-[iv]-(200)-|", options: [], metrics: nil, views: views),
            ].joined().map{$0})
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch which {
        case 1:
            let theMask = mask(size:self.iv.bounds.size, roundingCorners:20)
            self.iv.layer.mask = theMask
        case 2:
            let theMask = viewMask(size:self.iv.bounds.size, roundingCorners:20)
            print(self.iv.layer.mask as Any)

            self.iv.mask = theMask
            /// 自动调整在掩码视图上不起作用

            print(self.iv.layer.mask as Any)
        default: break
        }
    }

    @IBAction func showLayerHierarchy() {
        let lay = CALayer()
        lay.frame = view.layer.bounds
        view.layer.addSublayer(lay)

        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).cgColor
        lay1.frame = CGRect(113, 111, 132, 194)
        lay.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).cgColor
        lay2.frame = CGRect(41, 56, 132, 194)
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        lay3.frame = CGRect(43, 197, 160, 230)
        lay.addSublayer(lay3)

        let m = mask(size: CGSize(100,100), roundingCorners: 20)
        m.frame.origin = CGPoint(80,80)
        lay.mask = m
        // TODO: How to use?
        //lay.setValue(mask, forKey: "mask")
    }
    
}

