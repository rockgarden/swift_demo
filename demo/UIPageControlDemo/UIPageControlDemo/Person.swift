

import UIKit

class Person: UIViewController {
    
    var boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
//    init(pepBoy boy:String) {
//        self.boy = boy
//        // TODO: In my project, when nibName = nil, the name and pic don't init()
//        /// !!!: 原生Demo就可以!!!
//        super.init(nibName: "Person", bundle: nil)
//    }

    /// 添加“必需”来满足编译器担心类的“self”可能是一个子类 add "required" to satisfy the compiler's worry that class's "self" might be a subclass
    required init(pepBoy boy:String) {
        self.boy = boy
        super.init(nibName: "Person", bundle: nil)

        self.restorationIdentifier = "Person"
        // self.restorationClass = type(of:self) // * no restoration class, let app delegate point
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func encodeRestorableState(with coder: NSCoder) {
        // super.encodeRestorableStateWithCoder(coder)
        print("pep about to encode boy \(self.boy)")
        coder.encode(self.boy, forKey: "Person")
    }

    /// 直接解码 decode directly
    override func decodeRestorableState(with coder: NSCoder) {
        // super.decodeRestorableStateWithCoder(coder)
        let boy = coder.decodeObject(forKey: "Person")
        print("pep about to decode boy \(String(describing: boy))")
        if let boy = boy as? String {
            self.boy = boy
        }
    }

    /// one more step; in case we just did state restoration, match interface to newly assigned boy
    /// 相当于 viewDidLoad() : this is exactly the same as viewDidLoad()
    override func applicationFinishedRestoringState() {
        self.name.text = self.boy
        self.pic.image = UIImage(named:self.boy.lowercased())
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.boy
        name.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        self.pic.image = UIImage(named:self.boy.lowercased())
    }
    
    override var description : String {
        return self.boy
    }
    
    @IBAction func tap (_ sender: UIGestureRecognizer?) {
        NotificationCenter.default.post(name:.tap, object: sender)
    }
    
}
