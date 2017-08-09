//
//  SelfSizeTextField.swift
//  TextView
//
//  Created by wangkan on 2017/8/9.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import Foundation

enum ExpandDirection: Int {
    case expandToTop
    case expandToBottom
}

class SelfSizeTextField: UITextField {

    var expandDirection: ExpandDirection = .expandToBottom
    var numberOfLines: Int?
    var maxNumberOfLines: Int?
    var placeHolderStr: String?
    var heightConstraint: NSLayoutConstraint?
    var minHeight: CGFloat!
    var originalY: CGFloat!
    var bottomY: CGFloat!
    var previousRect: CGRect!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInit()
    }

    func setUpInit() {
        debugPrint(constraints)
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.height {
                heightConstraint = constraint as NSLayoutConstraint
                break
            }
        }
        heightConstraint?.isActive = false

        minHeight = frame.size.height
        originalY = frame.origin.y
        bottomY = frame.origin.y + frame.size.height
        previousRect = CGRect.zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        heightAnchor.constraint(equalToConstant: 28).isActive = true
        borderStyle = .none
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
        layer.masksToBounds = true
        textAlignment = .center
    }

    func textViewDidChange() {
        if (text?.characters.count == 0) {
            numberOfLines = 1
            if (placeHolderStr != nil) { placeholder = placeHolderStr }
            return
        } else {
            placeholder = ""
        }
        let pos = endOfDocument
        let currentRect = caretRect(for: pos)
        maxNumberOfLines = maxNumberOfLines == nil ? 5 : maxNumberOfLines

        if (currentRect.origin.y != previousRect.origin.y){

            if (currentRect.origin.y > previousRect.origin.y) {
                numberOfLines! += 1
                if (numberOfLines! >= maxNumberOfLines! + 1) {
                    numberOfLines! = maxNumberOfLines!
                    return
                }
            } else {
                numberOfLines! -= 1
                if (numberOfLines! <= 0) {
                    numberOfLines = 1
                }
            }

            adjustViewHeight(currentRect)
            //contentOffset = CGPoint(x: 0, y: -1) //(0, -1);
            
        }
        previousRect = currentRect
    }

    private func adjustViewHeight(_ currentRect: CGRect) {
        let height = currentRect.origin.y + currentRect.size.height
        var frame = self.frame
        frame.size.height = max(minHeight, height)
        if ( expandDirection == .expandToTop) {
            if (height > minHeight) {
                frame.origin.y = bottomY - height
            } else {
                frame.origin.y = originalY
            }
        }
        self.frame = frame
        frame = self.bounds
    }

}
