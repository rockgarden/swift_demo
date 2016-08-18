

import UIKit

func imageOfSize(size:CGSize, _ whatToDraw:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    whatToDraw()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class ViewController: UIViewController {
    
    @IBOutlet weak var myButton2: UIButton!
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = imageOfSize(CGSizeMake(45,20), {
            let p = UIBezierPath(
                roundedRect: CGRectMake(0,0,45,20), cornerRadius: 8)
            p.stroke()
        })
        myButton.setBackgroundImage(image, forState: .Normal)
    }
    
    @IBAction func doButton(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
            () -> () in
            self.myButton.frame.origin.y += 20
            }, completion: {
                (finished:Bool) -> () in
                print("finished: \(finished)")
        })
    }
    
    @IBAction func doButton2(sender: AnyObject) {
        // showing some serious compression of the above syntax
        UIView.animateWithDuration(0.4, animations: {
            self.myButton2.frame.origin.y += 20
        }) {
            print("finished: \($0)") // must have either "_ in" or "$0"
        }
    }
    
}

