//
//  KBTabBarController.swift
//  KBKit
//
//  Created by Evan Dekhayser on 12/13/15.
//  Copyright © 2015 Xappox, LLC. All rights reserved.
//

import UIKit

open class KBTabBarController: UITabBarController {
	
	override open var keyCommands: [UIKeyCommand]?{
		guard let viewControllers = viewControllers else { return nil }
		
		let oneCommand = UIKeyCommand(input: "1", modifierFlags: [.command], action: #selector(KBTabBarController.oneCommand), discoverabilityTitle: "First Tab")
		let twoCommand = UIKeyCommand(input: "2", modifierFlags: [.command], action: #selector(KBTabBarController.twoCommand), discoverabilityTitle: "Second Tab")
		let threeCommand = UIKeyCommand(input: "3", modifierFlags: [.command], action: #selector(KBTabBarController.threeCommand), discoverabilityTitle: "Third Tab")
		let fourCommand = UIKeyCommand(input: "4", modifierFlags: [.command], action: #selector(KBTabBarController.fourCommand), discoverabilityTitle: "Fourth Tab")
		let fiveCommand = UIKeyCommand(input: "5", modifierFlags: [.command], action: #selector(KBTabBarController.fiveCommand), discoverabilityTitle: "Fifth Tab")
		var commands = [UIKeyCommand]()
		
		if viewControllers.count >= 1{ commands.append(oneCommand) }
		if viewControllers.count >= 2{ commands.append(twoCommand) }
		if viewControllers.count >= 3{ commands.append(threeCommand) }
		if viewControllers.count >= 4{ commands.append(fourCommand) }
		if viewControllers.count == 5{ commands.append(fiveCommand) }
		return commands
	}

	@objc fileprivate func oneCommand(){
		selectedIndex = 0
	}
	
	@objc fileprivate func twoCommand(){
		selectedIndex = 1
	}
	
	@objc fileprivate func threeCommand(){
		selectedIndex = 2
	}
	
	@objc fileprivate func fourCommand(){
		selectedIndex = 3
	}
	
	@objc fileprivate func fiveCommand(){
		selectedIndex = 4
	}
	
	open override var canBecomeFirstResponder : Bool {
		return true
	}

}
