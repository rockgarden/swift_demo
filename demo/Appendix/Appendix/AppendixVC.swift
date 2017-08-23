
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


class AppendixVC: UIViewController {

    @IBOutlet weak var v: UIView!

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("%@", #function)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("%@", #function)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("%@", #function)
        do {
            let d = dictionaryOfNames(self.view, self.v)
            debugPrint(d)

            NSLayoutConstraint.reportAmbiguity(self.view)
            NSLayoutConstraint.listConstraints(self.view)

            let _ = imageOfSize(CGSize(100,100)) {
                let con = UIGraphicsGetCurrentContext()!
                con.addEllipse(in: CGRect(0,0,100,100))
                con.setFillColor(UIColor.blue.cgColor)
                con.fillPath()
            }

            let _ = imageOfSize(CGSize(100,100), opaque:true) {
                let con = UIGraphicsGetCurrentContext()!
                con.addEllipse(in: CGRect(0,0,100,100))
                con.setFillColor(UIColor.blue.cgColor)
                con.fillPath()
            }


            let opts = UIViewAnimationOptions.autoreverse
            let xorig = self.v.center.x
            UIView.animate(times:3, duration:1, delay:0, options:opts, animations:{
                self.v.center.x += 100
            }, completion:{ _ in
                self.v.center.x = xorig
            })

            var arr = [1,2,3,4]
            arr.remove(at:[0,2])

            do { // without lend
                let content = NSMutableAttributedString(string:"Ho de ho")
                let para = NSMutableParagraphStyle()
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .byWordWrapping
                para.alignment = .center
                para.paragraphSpacing = 15
                content.addAttribute(
                    NSParagraphStyleAttributeName,
                    value:para, range:NSMakeRange(0,1))
            }

            let content = NSMutableAttributedString(string:"Ho de ho")
            content.addAttribute(NSParagraphStyleAttributeName,
                                 value:lend {
                                    (para:NSMutableParagraphStyle) in
                                    para.headIndent = 10
                                    para.firstLineHeadIndent = 10
                                    para.tailIndent = -10
                                    para.lineBreakMode = .byWordWrapping
                                    para.alignment = .center
                                    para.paragraphSpacing = 15
            }, range:NSMakeRange(0,1))


            let s = "howdy"
            let w = Wrapper(s)
            let thing : AnyObject = w
            let realthing = (thing as! Wrapper).p as String
            print(realthing)
        }

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

