//
//  TextViewAutoHeight.swift
//  TextViewAutoHeightDemo
//
//  Created by pc-laptp on 12/3/14.
//  Copyright (c) 2014 StreetCoding. All rights reserved.
//

import UIKit

class TextViewAutoHeight: UITextView {
    
    //MARK: attributes

    var maxHeight: CGFloat?
    var heightConstraint: NSLayoutConstraint?
   
    //MARK: initialize

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpInit()
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightConstraint?.isActive = false
        isScrollEnabled = false
        //setUpConstraint()
//        isScrollEnabled = false
//        let h = contentSize.height
//        if let maxHeight = self.maxHeight {
//            if h > maxHeight && !isScrollEnabled {
//                isScrollEnabled = true
//                heightConstraint?.constant = maxHeight
//                heightConstraint?.isActive = true
//            } else if h < maxHeight && isScrollEnabled {
//                isScrollEnabled = false
//                heightConstraint?.isActive = false
//            }
//        }
    }
    
    //MARK: private
    
    private func setUpInit() {
        debugPrint(constraints)
        for constraint in self.constraints {
            if constraint.firstAttribute == NSLayoutAttribute.height {
                self.heightConstraint = constraint as NSLayoutConstraint
                break
            }
        }
    }
    
    private func setUpConstraint() {
        var finalContentSize:CGSize = self.contentSize
        finalContentSize.width  += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0
        finalContentSize.height += (self.textContainerInset.top  + self.textContainerInset.bottom) / 2.0
        fixTextViewHeigth(finalContentSize)
    }
    
    private func fixTextViewHeigth(_ finalContentSize:CGSize) {
        if let maxHeight = self.maxHeight {
            var  customContentSize = finalContentSize;
            customContentSize.height = min(customContentSize.height, CGFloat(maxHeight))
            self.heightConstraint?.constant = customContentSize.height;
            if finalContentSize.height <= self.frame.height {
                let textViewHeight = (self.frame.height - self.contentSize.height * self.zoomScale)/2.0
                self.contentOffset = CGPoint(0, -(textViewHeight < 0.0 ? 0.0 : textViewHeight))
            }
        }
    }
}
