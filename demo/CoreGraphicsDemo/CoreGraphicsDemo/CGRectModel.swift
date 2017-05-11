//
//  CGRectModel.swift
//  CGRectDivide
//
//  Created by FrankLiu on 15/11/4.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

class CGRectModel {

    let rect: CGRect

    init(rect: CGRect) {
        self.rect = rect
    }

    func divided(_ amout: CGFloat, edge: CGRectEdge) -> (slice: CGRect, reminder: CGRect) {
        let (slice, reminder) = rect.divided(atDistance: amout, from: edge)
        return (slice, reminder)
    }

    func dividedWithPadding(_ padding: CGFloat, amout: CGFloat, edge: CGRectEdge) -> (slice: CGRect, reminder: CGRect) {
        let (slice, tmpReminder) = rect.divided(atDistance: amout, from: edge)
        let (_, reminder) = tmpReminder.divided(atDistance: padding, from: edge)
        return (slice, reminder)
    }
}
