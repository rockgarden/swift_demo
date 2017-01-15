//
//  PanGestureAction.swift
//  PanGestureView
//
//  Created by Arvindh Sukumar on 30/01/16.
//  Copyright © 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit

open class PanGestureAction: NSObject {
    open var swipeDirection: PanGestureViewSwipeDirection!
    open var backgroundColor: UIColor?
    open var tintColor: UIColor?
    open var image:UIImage?
    open var isActive:Bool = false
    open var didTriggerBlock: ((_ swipeDirection: PanGestureViewSwipeDirection) -> ())?
    
    public convenience init(swipeDirection: PanGestureViewSwipeDirection, image:UIImage?) {
        self.init()
        self.swipeDirection = swipeDirection
        self.image = image
    }
}
