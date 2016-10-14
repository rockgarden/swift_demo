//
//  KBNavigationController.swift
//  KBKit
//
//  Created by Evan Dekhayser on 12/13/15.
//  Copyright © 2015 Evan Dekhayser. All rights reserved.
//

import UIKit

open class KBNavigationController: UINavigationController {

    override open var keyCommands: [UIKeyCommand]?{
        if viewControllers.count < 2 { return [] }
        let leftCommand = UIKeyCommand(input: UIKeyInputLeftArrow, modifierFlags: [.command], action: #selector(KBNavigationController.backCommand), discoverabilityTitle: "Back")
        return [leftCommand]
    }
    
    @objc fileprivate func backCommand(){
        popViewController(animated: true)
    }
	
	open override var canBecomeFirstResponder : Bool {
		return true
	}

}
