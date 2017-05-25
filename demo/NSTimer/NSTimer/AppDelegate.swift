//
//  AppDelegate.swift
//  NSTimer
//
//  Created by wangkan on 16/8/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

}

public typealias TimerExcuteClosure = @convention(block) () -> ()

/// 把想要执行的操作放到了一个闭包里，然后把它设为userInfo。比较关键的地方在于这里的target是NSTimer自己了，这里防止了它去持有外部调用者的引用计数，比如我们的ViewController。切断了之前的联系之后，deinit就能正常调用了，也能正常调用timer.invalidate()了，timer失效的时候也会释放它对target的引用，从而能够正确的释放资源。
extension Timer {
    
    private class TimerActionBlockWrapper : NSObject {
        var block : TimerExcuteClosure
        init(block: @escaping TimerExcuteClosure) {
            self.block = block
        }
    }
    
    public class func scheduledTimerWithTimeInterval(_ ti:TimeInterval, closure: @escaping TimerExcuteClosure, repeats yesOrNo: Bool) -> Timer {
        return self.scheduledTimer(timeInterval: ti, target: self, selector: #selector(Timer.excuteTimerClosure(_:)), userInfo: TimerActionBlockWrapper(block: closure), repeats: true)
    }
    
    /// NSTimer的userInfo的类型是AnyObject，这意味这你不能直接把closure传给它，需要用unsafeBitCast来转一下: timer.userInfo as? TimerActionBlockWrapper
    @objc private class func excuteTimerClosure(_ timer: Timer) {
        if let action = timer.userInfo as? TimerActionBlockWrapper {
            action.block()
        }
    }
}
