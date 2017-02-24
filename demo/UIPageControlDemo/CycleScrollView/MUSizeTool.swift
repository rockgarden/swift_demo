//
//  MUSizeTool.swift
//  MUCycleScrollView
//
//  Created by qcm on 16/12/16.
//  Copyright © 2016年 ChengziVR. All rights reserved.
//

import UIKit

extension UIView {
        public var mu_width: CGFloat {
                get {
                        return self.frame.size.width
                }
        }
        
        public var mu_height: CGFloat {
                get {
                        return self.frame.size.height
                }
        }
        
        public var mu_x: CGFloat {
                get {
                        return self.frame.origin.x
                }
        }
        
        public var mu_y: CGFloat {
                get {
                        return self.frame.origin.y
                }
        }
        
        public var mu_size: CGSize {
                get {
                        return self.frame.size
                }
        }
        
        public var mu_right: CGFloat {
                get {
                        return self.frame.origin.x + self.frame.size.width
                }
        }
        
        public var mu_bottom: CGFloat {
                get {
                        return self.frame.origin.y + self.frame.size.height
                }
        }
}
