

import UIKit

class NSOperationVC: UIViewController {

    @IBOutlet var mv : MyMandelbrotView!
    
    @IBAction func doButton (sender:AnyObject!) {
        self.mv.drawThatPuppy()
    }

    
}
