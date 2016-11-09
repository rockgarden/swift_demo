
import UIKit

@objc enum Star : Int {
    case blue
    case white
    case yellow
    case red
}

class MyClass {
    var timer : Timer?
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1,
            target: self, selector: #selector(timerFired(_:)),
            userInfo: nil, repeats: true)
    }
     @objc func timerFired(_ t:Timer) { // will crash without @objc
        print("timer fired")
        self.timer?.invalidate()
    }
}

struct Pair {
    let x : Int
    let y : Int
}

class Womble : NSObject {
    override init() {
        super.init()
    }
}


class ViewController: UIViewController {
    
    typealias MyStringExpecter = (String) -> ()
    class StringExpecterHolder : NSObject {
        var f : MyStringExpecter!
    }

    func blockTaker(_ f:()->()) {}
    // - (void)blockTaker:(void (^ __nonnull)(void))f;
    func functionTaker(_ f:@convention(c)() -> ()) {}
    // - (void)functionTaker:(void (* __nonnull)(void))f;
    
    // overloading while hiding
    @nonobjc func dismissViewControllerAnimated(_ flag: Int, completion: (() -> Void)?) {}
    
    func say(string s:String) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // proving that Swift structs don't get the zeroing initializer
            // let p = Pair()
            let pp = CGPoint()
        }
        
        do {
            // conversion of String to C string
            let q = DispatchQueue(label: "MyQueue", attributes: [])
            let s = "MyQueue"
            let qq = DispatchQueue(label: s, attributes: [])
            let cs = "hello".utf8CString // UnsafePointer<Int8>
            if let cs2 = "hello".cString(using: String.Encoding.utf8) { // [CChar]?
                let ss = String(cString: cs2)
                print(ss)
            }
            
            let _ : Void = "hello".withCString {
                var cs = $0
                while cs.pointee != 0 {
                    print(cs.pointee)
                    cs = cs.successor()
                }
            }
            
            _ = q
            _ = qq
            _ = cs
        }
        
        do {
            let da = kDead
            print(da)
            
            setState(kDead)
            setState(kAlive)
            setState(State(rawValue:2)) // Swift can't stop you
            
            self.view.autoresizingMask = .flexibleWidth
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        do {
            UIGraphicsBeginImageContext(CGSize(width: 200,height: 200))
            let c = UIGraphicsGetCurrentContext()!
            let arr = [CGPoint(x:0,y:0),
                CGPoint(x:50,y:50),
                CGPoint(x:50,y:50),
                CGPoint(x:0,y:100),
            ]
            c.strokeLineSegments(between: arr)
            UIGraphicsEndImageContext()
        }
        
        do {
            UIGraphicsBeginImageContext(CGSize(width: 200,height: 200))
            let c = UIGraphicsGetCurrentContext()!
            let arr = UnsafeMutablePointer<CGPoint>.allocate(capacity: 4)
            arr[0] = CGPoint(x:0,y:0)
            arr[1] = CGPoint(x:50,y:50)
            arr[2] = CGPoint(x:50,y:50)
            arr[3] = CGPoint(x:0,y:100)
            let arrs = [CGPoint(x:0,y:0),CGPoint(x:50,y:50),
                        CGPoint(x:50,y:50),CGPoint(x:0,y:100)]
            c.strokeLineSegments(between: arrs)
            //CGContextStrokeLineSegments(c, arr, 4)
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.view.addSubview(UIImageView(image:im)) // just checking :)
        }
        
        do {
            let col = UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1.0)
            let comp = col.cgColor.components
            if let sp = col.cgColor.colorSpace {
                if sp.model == .rgb {
                    let red = comp?[0]
                    let green = comp?[1]
                    let blue = comp?[2]
                    let alpha = comp?[3]
                    print(red!, green!, blue!, alpha!)
                }
            }
        }
        
        do {
            // hold my beer and watch _this_!
            let arr = ["Mannyz", "Moey", "Jackx"]
            func sortByLastCharacter(_ s1: AnyObject,
                _ s2:AnyObject, _ context: UnsafeMutableRawPointer) -> Int {
                    let c1 = (s1 as! String).characters.last
                    let c2 = (s2 as! String).characters.last
                    return ((String(describing: c1)).compare(String(describing: c2))).rawValue
            }
            ///FIXME:
             let arr2 = (arr as NSArray).sortedArray(sortByLastCharacter as! @convention(c) (Any, Any, UnsafeMutableRawPointer?) -> Int, context: nil)
             print(arr2)
            let arr3 = (arr as NSArray).sortedArray({
                s1, s2, context in
                let c1 = (s1 as! String).characters.last
                let c2 = (s2 as! String).characters.last
                return ((String(describing: c1)).compare(String(describing: c2))).rawValue
            }, context:nil)
            print(arr3)
        }

        self.testTimer()
        
        do {
            let grad = CAGradientLayer()
            grad.colors = [
                UIColor.lightGray.cgColor,
                UIColor.lightGray.cgColor,
                UIColor.blue.cgColor
            ]

        }
        
        do {
            func f (_ s:String) {print(s)}
            // let thing = f as! AnyObject // crash
            let holder = StringExpecterHolder()
            holder.f = f
            let lay = CALayer()
            lay.setValue(holder, forKey:"myFunction")
            let holder2 = lay.value(forKey: "myFunction") as! StringExpecterHolder
            holder2.f("testing")
        }
        
        do {
            let mas = NSMutableAttributedString()
            let r = NSMakeRange(0,0) // not really, just making sure we compile
            mas.enumerateAttribute("HERE", in: r, options: []) {
                value, r, stop in
                if let value = value as? Int, value == 1  {
                    // ...
                    stop.pointee = true
                }
            }

        }
        
    }

    var myclass = MyClass()
    func testTimer() {
        self.myclass.startTimer()
    }



}

