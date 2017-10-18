
import UIKit
import WebKit
import AudioToolbox

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

class MyOtherClass : NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
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

    var myOptionalInt : Int? // Objective-C cannot see this

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

    func testVisibility1(what:Int) {}
    func testVisibility2(what:MyClass) {}
    @objc func say(string s:String) {}

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
            // proving that Swift structs don't get the zeroing initializer
            // let p = Pair()
            let pp = CGPoint()
        }

        do {

            let cs = ("hello" as NSString).utf8String
            let csArray = "hello".utf8CString
            if let cs2 = "hello".cString(using: .utf8) { // [CChar]
                let ss = String(validatingUTF8: cs2)
                print(ss!)
            }

            "hello".withCString {
                var cs = $0 // UnsafePointer<Int8>
                while cs.pointee != 0 {
                    print(cs.pointee)
                    cs += 1 // or: cs = cs.successor()
                }
            }

            //            _ = q
            //            _ = qq
            _ = cs
            
        }

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
            
            UIView.animateWithTimes(3, duration:1, delay:0, options:opts, animations:{
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
                    NSAttributedStringKey.paragraphStyle,
                    value:para, range:NSMakeRange(0,1))
            }

            let content = NSMutableAttributedString(string:"Ho de ho")
            content.addAttribute(NSAttributedStringKey.paragraphStyle,
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
            let da = kDead
            print(da)

            setState(kDead)
            setState(kAlive)
            setState(State(rawValue:2)) // Swift can't stop you

            self.view.autoresizingMask = .flexibleWidth
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        do {
            // structs have suppressed the functions
            // CGPoint.make(CGFloat(0), CGFloat(0))
            let ok = CGPoint(x:1, y:2).equalTo(CGPoint(x:1.0, y:2.0))
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
            struct Arrow {
                static let ARHEIGHT : CGFloat = 20
            }
            let myRect = CGRect(x: 10, y: 10, width: 100, height: 100)
            var arrow = CGRect.zero
            var body = CGRect.zero
            myRect.__divided(
                slice: &arrow, remainder: &body, atDistance: Arrow.ARHEIGHT, from: .minYEdge)
            let (arrowRect, bodyRect) = myRect.divided(atDistance: Arrow.ARHEIGHT, from: .minYEdge)

        }
        var which : Bool {return false}
        if which {
            let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
            var snd : SystemSoundID = 0
            AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        }

        do {
            class MyClass2 /*: NSObject*/ {
                var name : String?
            }
            let c = MyClass2()
            c.name = "cool"
            let arr = [c]
            let arr2 = arr as NSArray
            let name = (arr2[0] as? MyClass2)?.name
            print(name!)
        }

        do {
            let lay = CALayer()
            class MyClass2 /*: NSObject*/ {
                var name : String?
            }
            let c = MyClass2()
            c.name = "cool"
            lay.setValue(c, forKey: "c")
            let name = (lay.value(forKey: "c") as? MyClass2)?.name
            print(name as Any)
        }

        do {
            let lay = CALayer()
            lay.setValue(CGPoint(x:100,y:100), forKey: "point")
            lay.setValue([CGPoint(x:100,y:100)], forKey: "pointArray")
            let point = lay.value(forKey:"point")
            let pointArray = lay.value(forKey:"pointArray")
            print(type(of:point!))
            print(type(of:pointArray!))
        }

        do {
            let s = "hello"
            let s2 = s.replacingOccurrences(of: "ell", with:"ipp")
            // s2 is now "hippo"
            print(s2)
        }

        do {
            let sel = #selector(doButton)
            print(sel)
            let sel2 = #selector(makeHash as ([String]) -> Void)
            print(sel2)
            let sel3 = #selector(makeHash as ([Int]) -> Void)
            print(sel3)

            let arr = NSArray(objects:1,2,3)
        }

        do {
            // hold my beer and watch _this_!

            let arr = ["Mannyz", "Moey", "Jackx"]
            // @convention(c) (Any, Any, UnsafeMutableRawPointer?) -> Int, context: UnsafeMutableRawPointer?) -> [Any]
            func sortByLastCharacter(_ s1:Any,
                                     _ s2:Any, _ context: UnsafeMutableRawPointer?) -> Int { // *
                let c1 = (s1 as! String).characters.last!
                let c2 = (s2 as! String).characters.last!
                return ((String(c1)).compare(String(c2))).rawValue
            }
            let arr2 = (arr as NSArray).sortedArray(sortByLastCharacter, context: nil)
            print(arr2)
            let arr3 = (arr as NSArray).sortedArray({
                s1, s2, context in
                let c1 = (s1 as! String).characters.last!
                let c2 = (s2 as! String).characters.last!
                return ((String(c1)).compare(String(c2))).rawValue
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
            mas.enumerateAttribute(NSAttributedStringKey(rawValue: "HERE"), in: r, options: []) {
                value, r, stop in
                if let value = value as? Int, value == 1  {
                    // ...
                    stop.pointee = true
                }
            }
            
        }

        self.reportSelectors()
        
    }

    func inverting(_:AppendixVC) -> AppendixVC {
        return AppendixVC()
    }

    @IBAction func doButton(_ sender: Any?) {

    }

    @objc func makeHash(ingredients stuff:[String]) {

    }

    @objc func makeHash(of stuff:[Int]) {

    }

    override func prepare(for war: UIStoryboardSegue, sender trebuchet: Any?) {
        // ...
    }

    override func canPerformAction(_ action: Selector,
                                   withSender sender: Any?) -> Bool {
        if action == #selector(undo) {
        }
        return true
    }

    @objc func undo() {}
    
    var myclass = MyClass()
    func testTimer() {
        self.myclass.startTimer()
    }
    
    @objc func sayHello() -> String // "sayHello"
    { return "ha"}

    @objc func say(_ s:String) // "say:"
    {}

    @objc func say(_ s:String, times n:Int) // "say:times:"
    {}

    @objc func say(of s:String, loudly:Bool)
    {}

    func reportSelectors() {
        print(#selector(self.sayHello))
        print(#selector(self.say(_:)))
        print(#selector(self.say(string:)))
        print(#selector(self.say(_:times:)))
        print(#selector(self.say(of:loudly:)))
    }
    
}

