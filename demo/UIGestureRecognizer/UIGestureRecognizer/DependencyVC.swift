

import UIKit

class DependencyVC : UIViewController, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ g: UIGestureRecognizer, shouldRequireFailureOf og: UIGestureRecognizer) -> Bool {
        
        let enc : String.Encoding = .utf8
        let s1 = NSString(cString: object_getClassName(g), encoding: enc.rawValue)
        let s2 = NSString(format:"%p", g.view!)
        let s3 = NSString(cString: object_getClassName(og), encoding: enc.rawValue)
        let s4 = NSString(format:"%p", og.view!)
        
        if s1 == "_UISystemGestureGateGestureRecognizer" { return false }
        if s3 == "_UISystemGestureGateGestureRecognizer" { return false }
        
        print("should \(String(describing: s1)) on \(s2) require failure of \(String(describing: s3)) on \(s4)")
        
        return false
    }
    
    func gestureRecognizer(_ g: UIGestureRecognizer, shouldBeRequiredToFailBy og: UIGestureRecognizer) -> Bool {
        
        let enc : String.Encoding = .utf8
        let s1 = NSString(cString: object_getClassName(g), encoding: enc.rawValue)
        let s2 = NSString(format:"%p", g.view!)
        let s3 = NSString(cString: object_getClassName(og), encoding: enc.rawValue)
        let s4 = NSString(format:"%p", og.view!)
        
        if s1 == "_UISystemGestureGateGestureRecognizer" { return false }
        
        print("should \(String(describing: s1)) on \(s2) be required to fail by \(String(describing: s3)) on \(s4)")
        
        return false
    }
    
}
