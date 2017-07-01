//
//  ConstraintsOrderOfEvents.swift
//  Constraint
//
//  Created by wangkan on 2016/11/6.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ConstraintsOrderOfEventsView: UIView {

    @IBInspectable var name : String?
    // new Xcode 6 feature, edit properties in Attributes inspector instead of Runtime Attributes 在属性检查器中编辑属性，而不是运行时属性
    // Apple claims: Bool, number, String, CGRect, CGPoint, CGSize, UIColor, NSRange, or an Optional
    @IBInspectable var myBool : Bool = false
    @IBInspectable var myString : String = "howdy"
    @IBInspectable var myInt : Int? = 1
    @IBInspectable var myDouble : Double? = 1
    @IBInspectable var myRect : CGRect? = CGRect.zero
    @IBInspectable var myPoint : CGPoint? = CGPoint.zero
    @IBInspectable var mySize : CGSize? = CGSize.zero
    @IBInspectable var myColor : UIColor? = UIColor.red
    @IBInspectable var myImage : UIImage?
    //@IBInspectable var myRange : Range<Int>? = 1...3 // nope
    //@IBInspectable var someView : UIView? // nope

    override var description : String {
        return super.description + "\n" + (self.name ?? "noname")
    }

    override func updateConstraints() {
        super.updateConstraints()
        print("\(self)\n\(#function)\n")
    }

    // gets an extra cycle
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of:layer)
        print("\(self)\n\(#function)\n")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(self)\n\(#function)\n")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("\(self)\n\(#function)\n")
        let prev : UITraitCollection? = previousTraitCollection
        if prev == nil {
            print("nil")
        }
        print("old: \(String(describing: prev) )\n")
    }

    override class var layerClass : AnyClass {
        return MyLoggingLayer.self
    }
}

class MyLoggingLayer : CALayer {
    override func layoutSublayers() {
        super.layoutSublayers()
        guard let del = self.delegate else {return}
        print("layer of \(del)\n\(#function)\n")
    }
}

