

import UIKit

protocol FlipsideViewControllerDelegate: class {
	func flipsideViewControllerDidFinish(_ controller: FlipsideViewController)
}

class FlipsideViewController: UIViewController {

	weak var delegate: FlipsideViewControllerDelegate!
    var cancelableTimer : CancelableTimer!
	var timer: Timer!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("starting timer")
		self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dummy), userInfo: nil, repeats: true)
		self.timer.tolerance = 0.1
        
        self.cancelableTimer = CancelableTimer(once: false) {
            [unowned self] in // comment out this line to leak
            self.dummy()
        }
        print("starting timer")
        self.cancelableTimer.startWithInterval(1)
	}
    
	func dummy() {
		print("timer fired")
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
//		return; // uncomment and we will leak
		print("invalidate")
		self.timer?.invalidate()
	}

	@IBAction func done (_ sender: AnyObject!) {
		print("done")
		self.delegate?.flipsideViewControllerDidFinish(self)
	}

	// if deinit is not called when you tap Done, we are leaking
	deinit {
		print("deinit")
        self.cancelableTimer?.cancel()
	}

}

extension FlipsideViewController: UIBarPositioningDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		return .top
	}
}
