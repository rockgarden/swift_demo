
import UIKit


/// map.jpg若是加入Assets中，只能作为1x资源，否则会缩收，也就是说若要显业原图大小最作为独立的资源文件。
class DragInSV_Constraint : UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var sv : UIScrollView!
    @IBOutlet var flag : UIImageView!
    @IBOutlet weak var swipe: UISwipeGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        /// 关闭Constraints，允许拖动
        flag.translatesAutoresizingMaskIntoConstraints = true

        sv.panGestureRecognizer.require(toFail: swipe)

        let iv = UIImageView(image: UIImage(named:"smiley"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        sv.addSubview(iv)
        let sup = sv.superview!
        NSLayoutConstraint.activate([
            iv.rightAnchor.constraint(equalTo:sup.rightAnchor, constant: -5),
            iv.topAnchor.constraint(equalTo:topLayoutGuide.bottomAnchor, constant: 25)
            ])

        //        delay(2) {
        //            print(self.view.subviews)
        //        }
    }

    // delegate of flag's pan gesture recognizer

    // perhaps this was a bug? I can't reproduce the problem any more

    //    func gestureRecognizer(g: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer og: UIGestureRecognizer!) -> Bool {
    //        print(g)
    //        print(og)
    //        return true // keep our flag gesture recognizer first
    //        // trying to avoid weird behavior where sometimes pan gesture fails
    //    }

    @IBAction func swiped (_ g: UISwipeGestureRecognizer) {
        let sv = self.sv!
        let p = sv.contentOffset
        self.flag.frame.origin = p
        self.flag.frame.origin.x -= self.flag.bounds.width
        self.flag.isHidden = false

        UIView.animate(withDuration:0.25) {
            self.flag.frame.origin.x = p.x
            g.isEnabled = false
        }
    }

    @IBAction func dragging (_  p: UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview!)
            v.center.x += delta.x
            v.center.y += delta.y
            p.setTranslation(.zero, in: v.superview)
            if p.state == .changed {fallthrough} // comment out to prevent autoscroll
        case .changed:
            // autoscroll
            let sv = self.sv!
            let loc = p.location(in:sv)
            let f = sv.bounds
            var off = sv.contentOffset
            let sz = sv.contentSize
            var c = v.center
            // to the right
            if loc.x > f.maxX - 30 {
                let margin = sz.width - sv.bounds.maxX
                if margin > 6 {
                    off.x += 5
                    sv.contentOffset = off
                    c.x += 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the left
            if loc.x < f.origin.x + 30 {
                let margin = off.x
                if margin > 6 {
                    off.x -= 5
                    sv.contentOffset = off
                    c.x -= 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the bottom
            if loc.y > f.maxY - 30 {
                let margin = sz.height - sv.bounds.maxY
                if margin > 6 {
                    off.y += 5
                    sv.contentOffset = off
                    c.y += 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the top
            if loc.y < f.origin.y + 30 {
                let margin = off.y
                if margin > 6 {
                    off.y -= 5
                    sv.contentOffset = off
                    c.y -= 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
        default: break
        }
    }

    func keepDragging (_ p: UIPanGestureRecognizer) {
        let del = 0.1
        delay(del) {
            self.dragging(p)
        }
    }
    
}
