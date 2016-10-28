
import UIKit

class ViewController: UIViewController {

    func dogMyCats(_ s:String) -> String {
        return "dogs"
    }

    @IBAction func buttonPressed(_ sender:AnyObject) {
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

