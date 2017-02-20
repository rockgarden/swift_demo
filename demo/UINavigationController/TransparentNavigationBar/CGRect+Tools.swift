//
//  CGRect+Tools.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

enum Direction {
    case top, bottom, left, right
}

extension CGRect {
    func additiveRect(_ value: CGFloat, direction: Direction) -> CGRect {
        
        var rect = self
        
        switch direction {
        case .top:
            rect.origin.y -= value
            rect.size.height += value
        case .bottom:
            rect.size.height += value
        case .left:
            rect.origin.x -= value
            rect.size.width += value
        case .right:
            rect.size.width += value
        }
        
        return rect
    }
}
