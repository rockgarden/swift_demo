//
//  MyObject.swift
//  Protocol-Delegate
//
//  Created by Carlos Butron on 05/11/15.
//  Copyright © 2015 Carlos Butron. All rights reserved.
//

import UIKit

protocol myObjectDelegate {
    func delegateMethod()
}

class myObject: NSObject {
    
    var delegate: myObjectDelegate?
    
    func start() {
    delegate?.delegateMethod()
    }
    
}
