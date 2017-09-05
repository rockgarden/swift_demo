
import UIKit

class Main_UIResponder: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mc = MyClass()
        
        if mc.responds(to: #selector(Dummy.woohoo)) {
            print("here1")
            (mc as AnyObject).woohoo()
        }
        
        let mc2 = MyClass2()
        debugPrint("#selector:", #selector(Dummy.woohoo), mc2.responds(to: #selector(Dummy.woohoo)))
        if mc2.responds(to: #selector(Dummy.woohoo)) {
            print("here2")
            (mc2 as AnyObject).woohoo()
        }
        
        (mc as AnyObject).woohoo?() //No woohoo
        (mc2 as AnyObject).woohoo?()
    }

}

class MyClass : NSObject {}

class MyClass2 : NSObject {
    func woohoo() {
        print("woohoo")
    }
}

@objc protocol Dummy {
    func woohoo()
}
