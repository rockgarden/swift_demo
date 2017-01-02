
import UIKit

class UISegmentedControlVC: UIViewController {

    @IBOutlet var seg : UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.seg.layer.speed = 0.2
        delay(1) {
            UIView.animate(withDuration:0.4) {
                self.seg.selectedSegmentIndex = 1
            }
        }

        // self.seg.tintColor = .red
        // return

        /// background, set desired height but make width resizable sufficient to set for Normal only
        let sz = CGSize(100,60)
        var im : UIImage!
        if #available(iOS 10.0, *) {
            im = UIGraphicsImageRenderer(size:sz).image {_ in
                UIImage(named:"linen")!.draw(in:CGRect(origin: .zero, size:sz))
                }.resizableImage(withCapInsets:UIEdgeInsetsMake(0,10,0,10), resizingMode: .stretch)
        } else {
            im = imageOfSize(sz) {
                UIImage(named:"linen.png")!.draw(in:CGRect(origin: CGPoint(), size:sz))
                }.resizableImage(withCapInsets:UIEdgeInsetsMake(0,10,0,10), resizingMode:.stretch)
        }
        self.seg.setBackgroundImage(im, for:.normal, barMetrics: .default)

        // segment images, redraw at final size
        let pep = ["manny", "moe", "jack"]
        for (i, boy) in pep.enumerated() {
            var im : UIImage!
            let sz = CGSize(30,30)
            if #available(iOS 10.0, *) {
                im = UIGraphicsImageRenderer(size:sz).image {_ in
                    UIImage(named:boy)!.draw(in:CGRect(origin: .zero, size: sz))
                    }.withRenderingMode(.alwaysOriginal)
            } else {
                im = imageOfSize(sz) {
                    UIImage(named:boy)!.draw(in:CGRect(origin: .zero, size: sz))
                    }.withRenderingMode(.alwaysOriginal)
            }
            self.seg.setImage(im, forSegmentAt: i)
            self.seg.setWidth(80, forSegmentAt: i)
        }

        // divider, set at desired width, sufficient to set for Normal only
        let sz2 = CGSize(2,10)
        var div : UIImage!
        if #available(iOS 10.0, *) {
            div = UIGraphicsImageRenderer(size:sz2).image { ctx in
                UIColor.white.set()
                ctx.fill(CGRect(origin: .zero, size: sz2))
            }
        } else {
            div = imageOfSize(sz) {
                UIColor.white.set()
                UIGraphicsGetCurrentContext()!.fill(CGRect(origin: CGPoint(), size: sz))
            }
        }
        self.seg.setDividerImage(div, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        let seg = UISegmentedControl(
            items: [
                UIImage(named:"smiley")!.withRenderingMode(.alwaysOriginal),
                "Two"
            ])
        seg.frame.origin = CGPoint(40,100)
        seg.frame.size.width = 200
        self.view.addSubview(seg)
    }

}
