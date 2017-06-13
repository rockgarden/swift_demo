
import UIKit

class BaseActivity: UIActivity {

    var items : [Any]?
    var image : UIImage

    override init() {
        let idiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var scale : CGFloat = (idiom == .pad ? 76 : 60) - 10
        let im = UIImage(named:"sunglasses.png")!
        let largerSize = fmax(im.size.height, im.size.width)
        scale /= largerSize
        let sz = CGSize(im.size.width*scale, im.size.height*scale)
        let r = UIGraphicsImageRenderer(size:sz)
        self.image = r.image { _ in
            im.draw(in:CGRect(origin: .zero, size: sz))
        }
        super.init()
    }

    override class var activityCategory : UIActivityCategory {
        return .action //the default
    }

    override var activityImage : UIImage? {
        return self.image
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        print("prepare \(activityItems)")
        self.items = activityItems
    }

    deinit {
        print("activity dealloc")
    }

}


class CoolActivity : BaseActivity {

    override var activityType : UIActivityType {
        return UIActivityType("com.neuburg.matt.coolActivity")
    }
    
    override var activityTitle : String? {
        return "Be Cool"
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        print("cool can perform \(activityItems)")
        for obj in activityItems {
            if obj is String {
                print("returning true")
                return true
            }
        }
        print("returning false")
        return false
    }

    override func perform() {
        print("cool performing \(String(describing: self.items))")
        self.activityDidFinish(true)
    }

}

class ElaborateActivity : BaseActivity {

    override var activityType : UIActivityType? {
        return UIActivityType("com.neuburg.matt.elaborateActivity")
    }

    override var activityTitle : String? {
        return "Elaborate"
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        print("elaborate can perform \(activityItems)")
        print("returning true")
        return true
    }

    override var activityViewController : UIViewController? {
        let mvc = MustacheViewController(activity: self, items: self.items!)
        return mvc
    }

}

