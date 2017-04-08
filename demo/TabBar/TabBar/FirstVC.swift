
import UIKit

class FirstViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor.black
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = UIColor.yellow
        } else {
            // Fallback on earlier versions
        }
        
        /// TODO: badgeValue 只有在此设置才有效? UITabBarController 中无法设置?
        guard let tabBarItem = self.tabBarItem else { return }
        debugPrint(tabBarItem)
        tabBarItem.badgeValue = "123"
        if #available(iOS 10.0, *) {
            tabBarItem.badgeColor = UIColor.blue
        } else {
            // Fallback on earlier versions
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}


/// tab bar delegate gets to dictate orientations... so there's no need to subclass UITabBarController
extension FirstViewController: UITabBarControllerDelegate {
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(#function)
        return .portrait
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(#function)
        return .landscape // called, but pointless
    }

}
