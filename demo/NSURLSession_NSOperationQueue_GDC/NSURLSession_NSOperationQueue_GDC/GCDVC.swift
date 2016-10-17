//
//  GCDVC.swift
//  NSURLSession_NSOperationQueue_GDC
//
//  Created by wangkan on 16/8/17.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class GCDVC: UIViewController {

    var mv : GCD_MandelbrotView!

    func doButton (_ sender:AnyObject!) {
        self.mv.drawThatPuppy()
    }
    
}
