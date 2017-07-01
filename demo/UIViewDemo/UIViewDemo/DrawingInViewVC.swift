
import UIKit

class DrawClearRectVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let mv = ClearRectView(frame:CGRect.zero)
        self.view.addSubview(mv)
        mv.translatesAutoresizingMaskIntoConstraints = false
        
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-25-[v(100)]", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"V:[v(100)]", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraint(
            NSLayoutConstraint(item: mv, attribute: .centerY, relatedBy: .equal, toItem: mv.superview, attribute: .centerY, multiplier: 1, constant: 0)
        )
    }

}


class ClearRectView : UIView {

    override init (frame:CGRect) {
        super.init(frame:frame)
        self.isOpaque = false
        self.backgroundColor = .red
        // clearRect will cause a black square
        self.backgroundColor = self.backgroundColor!.withAlphaComponent(1)
        // uncomment the next line: clearRect will cause a clear square!
        //self.backgroundColor = self.backgroundColor!.withAlphaComponent(0.99)

        print("Layer opaque: \(self.layer.isOpaque)")
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(UIColor.blue.cgColor)
        con.fill(rect)
        con.clear(CGRect(0,0,30,30))
    }
    
}
