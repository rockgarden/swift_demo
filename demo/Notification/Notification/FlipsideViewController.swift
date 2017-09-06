

import UIKit

protocol FlipsideViewControllerDelegate : class {
    func flipsideViewControllerDidFinish(_ controller: FlipsideViewController)
}

/// Test leaker
class FlipsideViewController: UIViewController {
    
    weak var delegate : FlipsideViewControllerDelegate!
    
    var observer : AnyObject!
    var timer : Timer!

    let which = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("starting timer")
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                [unowned self] //comment out and we will leak
                t in
                self.fired(t)
            }
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fired), userInfo: nil, repeats: true)
        }
        self.timer.tolerance = 0.1

        switch which {
        case 0:
            self.observer = NotificationCenter.default.addObserver(
                forName: NSNotification.Name(rawValue: "woohoo"), object:nil, queue:nil) {
                    _ in
                    self.description //leak me, leak me
            }
        case 1:
            self.observer = NotificationCenter.default.addObserver(
                forName: NSNotification.Name(rawValue: "woohoo"), object:nil, queue:nil) {
                    [unowned self] _ in //ha ha, fixed it
                    self.description
            }
        default:break
        }
    }

    @objc private func fired(_ t:Timer) {
        print("timer fired")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("unregister")
        NotificationCenter.default.removeObserver(self.observer)
    }
    
    @IBAction func done (_ sender: AnyObject!) {
        print("done")
        self.delegate?.flipsideViewControllerDidFinish(self)
    }
    
    // if deinit is not called when you tap Done, we are leaking
    deinit {
        timer.invalidate()
        print("deinit")
    }
    
}

extension FlipsideViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
