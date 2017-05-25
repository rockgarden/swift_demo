
import UIKit

class CancelableTimer: NSObject {
	fileprivate var q = DispatchQueue(label: "timer", attributes: [])
	fileprivate var timer: DispatchSourceTimer!
    fileprivate var timerOld: DispatchSource!
	fileprivate var firsttime = true
	fileprivate var once: Bool
	fileprivate var handler: () -> ()
    
	init(once: Bool, handler: @escaping () -> ()) {
		self.once = once
		self.handler = handler
		super.init()
	}
    
    func start(withInterval interval:Double) {
        self.firsttime = true
        self.cancel()
        self.timer = DispatchSource.makeTimerSource(queue: self.q)
        self.timer.scheduleRepeating(wallDeadline: .now(), interval: interval)
        // self.timer.scheduleRepeating(deadline: .now(), interval: 1, leeway: .milliseconds(1))
        self.timer.setEventHandler {
            if self.firsttime {
                self.firsttime = false
                return
            }
            self.handler()
            if self.once {
                self.cancel()
            }
        }
        self.timer.resume()
    }

	func startWithIntervalOld(_ interval: Double) {
		self.firsttime = true
		self.cancel()
		self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: self.q) /*Migrator FIXME: Use DispatchSourceTimer to avoid the cast*/ as! DispatchSource
        self.timer.scheduleRepeating(deadline: .now(), interval: 1, leeway: .milliseconds(1))
//		self.timer.setTimer(start: DispatchWallTime(time: nil),
//			interval: UInt64(interval * Double(NSEC_PER_SEC)),
//			leeway: UInt64(0.05 * Double(NSEC_PER_SEC)))
		self.timer.setEventHandler(handler: {
			if self.firsttime {
				self.firsttime = false
				return
			}
			self.handler()
			if self.once {
				self.cancel()
			}
		})
		self.timer.resume()
	}
    
	func cancel() {
		if self.timer != nil {
			timer.cancel()
		}
	}
    
	deinit {
		print("deinit cancelable timer")
	}
}
