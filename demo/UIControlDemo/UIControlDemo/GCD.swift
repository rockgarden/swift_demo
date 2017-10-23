//
//  GCD.swift
//  CircleRipple
//

import Foundation

class GCD {
    
    class func async(_ block: @escaping ()->()) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    class func main(_ block: @escaping ()->()) {
        DispatchQueue.main.async(execute: block)
    }
    
    class func delay(_ delaySeconds: Double, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
}
