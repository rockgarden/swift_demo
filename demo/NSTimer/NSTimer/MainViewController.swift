import UIKit

class MainViewController: UIViewController, FlipsideViewControllerDelegate {

	func flipsideViewControllerDidFinish(_ controller: FlipsideViewController) {
		self.dismiss(animated: true, completion: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showAlternate" {
			if let dest = segue.destination as? FlipsideViewController {
				dest.delegate = self
			}
		}
	}

}
