
import UIKit

extension UICoordinateSpace {
    static func convertRect(_ r:CGRect,
                            fromCoordinateSpace s1:UICoordinateSpace,
                            toCoordinateSpace s2:UICoordinateSpace) -> CGRect {
        return s1.convert(r, to:s2)
    }
}

class ViewController: UIViewController {

    @IBAction func doButton1(_ sender: UIButton) {
        let v = sender
        let r = v.superview!.convert(
            v.frame, to: UIScreen.main.fixedCoordinateSpace)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(
                v.frame, to: UIScreen.main.coordinateSpace)
            print(r)
            print(v.frame)
        }
    }
    
    @IBAction func doButton2(_ sender: UIButton) {
        let v = sender
        let r = v.superview!.convert(
            v.frame, to: UIScreen.main.fixedCoordinateSpace)
        print(r)
        print(v.frame)
        do {
            let r = v.superview!.convert(
                v.frame, to: UIScreen.main.coordinateSpace)
            print(r)
            print(v.frame)
        }
    }
    
    
}

