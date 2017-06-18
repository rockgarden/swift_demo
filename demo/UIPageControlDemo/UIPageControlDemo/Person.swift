

import UIKit

class Person: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    init(pepBoy boy:String) {
        self.boy = boy
        // TODO: In my project, when nibName = nil, the name and pic don't init()
        /// !!!: 原生Demo就可以!!!
        super.init(nibName: "Person", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
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
