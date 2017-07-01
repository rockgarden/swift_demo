import UIKit

class SixBlueCirclesVC : UIViewController {

}


class MyView1 : UIView {
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
        UIColor.blue.setFill()
        p.fill()
    }
}
class MyView2 : UIView {
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.addEllipse(in:CGRect(0,0,100,100))
        con.setFillColor(UIColor.blue.cgColor)
        con.fillPath()
    }
}
class MyView3 : UIView {
    override func draw(_ rect: CGRect) {}
    override func draw(_ layer: CALayer, in con: CGContext) {
        UIGraphicsPushContext(con)
        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
        UIColor.blue.setFill()
        p.fill()
        UIGraphicsPopContext()
    }
}
class MyView4 : UIView {
    override func draw(_ rect: CGRect) {}
    override func draw(_ layer: CALayer, in con: CGContext) {
        con.addEllipse(in:CGRect(0,0,100,100))
        con.setFillColor(UIColor.blue.cgColor)
        con.fillPath()
    }
}
class MyImageView1 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 10.0, *) {
            let f = UIGraphicsImageRendererFormat.default()
            _ = f
            
            let r = UIGraphicsImageRenderer(size:CGSize(100,100))
            self.image = r.image { _ in
                let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
                UIColor.blue.setFill()
                p.fill()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
class MyImageView2 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()

        var which : Int {return 0}
        switch which {
        case 0:
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(100,100))
                self.image = r.image {ctx in
                    // let con = ctx.cgContext
                    // could say that, but the old way works still
                    let con = UIGraphicsGetCurrentContext()!
                    con.addEllipse(in:CGRect(0,0,100,100))
                    con.setFillColor(UIColor.blue.cgColor)
                    con.fillPath()
                }
            } else {
                // Fallback on earlier versions
            }
        case 1: // just showing how to use my utility
            self.image = imageOfSize(CGSize(100, 100)) {
                let con = UIGraphicsGetCurrentContext()!
                con.addEllipse(in:CGRect(0,0,100,100))
                con.setFillColor(UIColor.blue.cgColor)
                con.fillPath()
            }
        default:break
        }
    }
}

