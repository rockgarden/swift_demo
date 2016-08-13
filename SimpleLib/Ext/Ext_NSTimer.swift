//
//  Ext_NSTimer.swift
//  mobile112
//
//  Created by wangkan on 16/8/13.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation

extension NSTimer {
	/// EZSE: Runs every x seconds, to cancel use: timer.invalidate()
	public static func runThisEvery(seconds seconds: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
		let fireDate = CFAbsoluteTimeGetCurrent()
		let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
		CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
		return timer
	}

	/// EZSE: Run function after x seconds
	public static func runThisAfterDelay(seconds seconds: Double, after: () -> ()) {
		runThisAfterDelay(seconds: seconds, queue: dispatch_get_main_queue(), after: after)
	}

	// TODO: Make this easier
	/// EZSwiftExtensions - dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
	public static func runThisAfterDelay(seconds seconds: Double, queue: dispatch_queue_t, after: () -> ()) {
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
		dispatch_after(time, queue, after)
	}

	public typealias TimerExcuteClosure = @convention(block)() -> ()
	/**
	 OC模式的NSTimer
	 把想要执行的操作放到了一个闭包里，然后把它设为userInfo。比较关键的地方在于这里的target是NSTimer自己了，这里防止了它去持有外部调用者的引用计数，比如我们的ViewController。切断了之前的联系之后，deinit就能正常调用了，也能正常调用timer.invalidate()了，timer失效的时候也会释放它对target的引用，从而能够正确的释放资源。

	 - parameter ti:      <#ti description#>
	 - parameter closure: <#closure description#>
	 - parameter yesOrNo: <#yesOrNo description#>

	 - returns: <#return value description#>
	 */
	public class func OC_ScheduledTimerWithTimeInterval(ti: NSTimeInterval, closure: TimerExcuteClosure, repeats yesOrNo: Bool) -> NSTimer {
		return self.scheduledTimerWithTimeInterval(ti, target: self, selector: #selector(NSTimer.excuteTimerClosure(_:)), userInfo: unsafeBitCast(closure, AnyObject.self), repeats: true)
	}

	class func excuteTimerClosure(timer: NSTimer)
	{
		let closure = unsafeBitCast(timer.userInfo, TimerExcuteClosure.self)
		closure()
	}

}

extension NSTimer {

    // MARK: Schedule timers

    /// Create and schedule a timer that will call `block` once after the specified time.

    public class func after(interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        let timer = NSTimer.new(after: interval, block)
        timer.start()
        return timer
    }

    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.

    public class func every(interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        let timer = NSTimer.new(every: interval, block)
        timer.start()
        return timer
    }

    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)

    @nonobjc public class func every(interval: NSTimeInterval, _ block: NSTimer -> Void) -> NSTimer {
        let timer = NSTimer.new(every: interval, block)
        timer.start()
        return timer
    }

    // MARK: Create timers without scheduling

    /// Create a timer that will call `block` once after the specified time.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.after` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)

    public class func new(after interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }

    /// Create a timer that will call `block` repeatedly in specified time intervals.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)

    public class func new(every interval: NSTimeInterval, _ block: () -> Void) -> NSTimer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }

    /// Create a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)

    @nonobjc public class func new(every interval: NSTimeInterval, _ block: NSTimer -> Void) -> NSTimer {
        var timer: NSTimer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return timer
    }

    // MARK: Manual scheduling

    /// Schedule this timer on the run loop
    ///
    /// By default, the timer is scheduled on the current run loop for the default mode.
    /// Specify `runLoop` or `modes` to override these defaults.

    public func start(runLoop runLoop: NSRunLoop = NSRunLoop.currentRunLoop(), modes: String...) {
        let modes = modes.isEmpty ? [NSDefaultRunLoopMode] : modes

        for mode in modes {
            runLoop.addTimer(self, forMode: mode)
        }
    }
}

// MARK: - Time extensions

extension Double {
    public var millisecond: NSTimeInterval  { return self / 1000 }
    public var milliseconds: NSTimeInterval { return self / 1000 }
    public var ms: NSTimeInterval           { return self / 1000 }

    public var second: NSTimeInterval       { return self }
    public var seconds: NSTimeInterval      { return self }

    public var minute: NSTimeInterval       { return self * 60 }
    public var minutes: NSTimeInterval      { return self * 60 }

    public var hour: NSTimeInterval         { return self * 3600 }
    public var hours: NSTimeInterval        { return self * 3600 }

    public var day: NSTimeInterval          { return self * 3600 * 24 }
    public var days: NSTimeInterval         { return self * 3600 * 24 }
}