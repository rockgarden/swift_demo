

import UIKit

protocol FlipsideViewControllerDelegate: class {
	func flipsideViewControllerDidFinish(_ controller: FlipsideViewController)
}

class FlipsideViewController: UIViewController {

	weak var delegate: FlipsideViewControllerDelegate!
    var timer : CancelableTimer!
    
    let useOld = false
	var timerOld: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("creating timer")
        self.timer = CancelableTimer(once: false) {
            [unowned self] in // comment out this line to leak
            self.dummy()
        }
        print("starting timer")
        self.timer.start(withInterval:1)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        if useOld {
            print("starting timer")
            self.timerOld = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dummy), userInfo: nil, repeats: true)
            self.timerOld.tolerance = 0.1
            
            self.timer = CancelableTimer(once: false) {
                [unowned self] in // comment out this line to leak
                self.dummy()
            }
            print("starting timer")
            self.timer.startWithIntervalOld(1)
        }
	}
    
	func dummy() {
		print("timer fired")
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
        if useOld {
            //		return; // uncomment and we will leak
            print("invalidate")
            self.timerOld?.invalidate()
        }
	}

	@IBAction func done (_ sender: AnyObject!) {
		print("done")
		self.delegate?.flipsideViewControllerDidFinish(self)
	}

	// if deinit is not called when you tap Done, we are leaking
	deinit {
		print("deinit")
        self.timer?.cancel()
	}

}

extension FlipsideViewController: UIBarPositioningDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		return .top
	}
}
