
import UIKit

class OutletCollectionAndActionVC: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet var coolviews : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.button.addTarget(self,
                              action: #selector(buttonPressed),
                              for: .touchUpInside)

        self.button2.addTarget(nil, // nil-targeted
            action: #selector(buttonPressed),
            for: .touchUpInside)

        /// third button is configured as nil-targeted in nib

        /// When enumerating a collection, the integer part of each pair is a counter for the enumeration, not necessarily the index of the paired value.
        for (ix,b) in (self.coolviews as! [UIButton]).enumerated() {
            b.setTitle("B\(ix+1)", for: UIControlState())
        }
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func showResponderChain(_ sender: UIResponder) {
        var r : UIResponder! = sender
        repeat { print(r, "\n"); r = r.next } while r != nil
    }

    @IBAction func showVC(_ sender: Any) {
        let vc = NibLoadingVC()
        show(vc, sender: nil)
    }

    @IBAction func unwindOCAAVC(_ sender: UIStoryboardSegue) {}

    @IBAction func showNibVC(_ sender: Any) {
        guard let b = sender as? UIButton else {return}
        if b.tag == 101 {
            let vc = RootViewController(nibName:"MyNib", bundle:nil)
            show(vc, sender: nil)
        } else {
            /// 如果 RootViewController.xib 不存在则会找 File's Owner RootView.xib
            let vc = RootViewController()
            show(vc, sender: nil)
        }
    }

}

