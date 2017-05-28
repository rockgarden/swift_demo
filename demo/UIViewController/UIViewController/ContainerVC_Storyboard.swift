
import UIKit

class ContainerVC_Storyboard: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "embed" {
            NSLog("%@ %@ %@", segue.identifier!, segue.source, segue.destination)
            NSLog("%@", segue.destination.isViewLoaded as NSNumber)
            NSLog("%@", segue.source.childViewControllers)
            NSLog("%@", self.childViewControllers)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load", self.view, self.childViewControllers)
        print("child's view:", self.childViewControllers[0].viewIfLoaded as Any)
        print("child's view's superview:", self.childViewControllers[0].viewIfLoaded?.superview as Any)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear", self.view, self.childViewControllers)
    }

    @IBAction func doButton(_ sender: Any?) {
        presentingViewController!.dismiss(animated:true)
    }

}

class CVCS_EmbedVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("child did load", self.view, self.childViewControllers)
    }

}
