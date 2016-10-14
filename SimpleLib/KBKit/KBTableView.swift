//
//  KBTableView.swift
//  KBKit
//
//  响应键盘操作
//  Created by Evan Dekhayser on 12/13/15.
//  Copyright © 2015 Evan Dekhayser. All rights reserved.
//

import UIKit

open class KBTableView: UITableView {

	var onSelection: ((IndexPath) -> Void)?
	var onFocus: ((_ current: IndexPath?, _ previous: IndexPath?) -> Void)?
	fileprivate var currentlyFocussedIndex: IndexPath?

	override open var keyCommands: [UIKeyCommand]? {
		let upCommand = UIKeyCommand(input: UIKeyInputUpArrow, modifierFlags: [], action: #selector(KBTableView.upCommand), discoverabilityTitle: "Move Up")
		let downCommand = UIKeyCommand(input: UIKeyInputDownArrow, modifierFlags: [], action: #selector(KBTableView.downCommand), discoverabilityTitle: "Move Down")
		let returnCommand = UIKeyCommand(input: "\r", modifierFlags: [], action: #selector(KBTableView.returnCommand), discoverabilityTitle: "Enter")
		let escCommand = UIKeyCommand(input: UIKeyInputEscape, modifierFlags: [], action: #selector(KBTableView.escapeCommand), discoverabilityTitle: "Deselect")
		let otherEscCommand = UIKeyCommand(input: "d", modifierFlags: [.command], action: #selector(KBTableView.escapeCommand), discoverabilityTitle: "Deselect")

		var commands = [upCommand, downCommand]
		if let _ = currentlyFocussedIndex {
			commands += [returnCommand, escCommand, otherEscCommand]
		}
		return commands
	}

	open func stopHighlighting() {
		onFocus?(nil, currentlyFocussedIndex)
		currentlyFocussedIndex = nil
	}

	@objc fileprivate func escapeCommand() {
		stopHighlighting()
	}

	@objc fileprivate func upCommand() {
		guard let previouslyFocussedIndex = currentlyFocussedIndex else {
			currentlyFocussedIndex = indexPathForAbsoluteRow(numberOfTotalRows() - 1)
			onFocus?(currentlyFocussedIndex, nil)
			return
		}

		if (previouslyFocussedIndex as NSIndexPath).row > 0 {
			currentlyFocussedIndex = IndexPath(row: (previouslyFocussedIndex as NSIndexPath).row - 1, section: (previouslyFocussedIndex as NSIndexPath).section)
		} else if (previouslyFocussedIndex as NSIndexPath).section > 0 {
			var section = (previouslyFocussedIndex as NSIndexPath).section - 1
			while section >= 0 {
				if numberOfRows(inSection: section) > 0 {
					break
				} else {
					section -= 1
				}
			}
			if section >= 0 {
				currentlyFocussedIndex = IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
			} else {
				currentlyFocussedIndex = indexPathForAbsoluteRow(numberOfTotalRows() - 1)
			}
		} else {
			currentlyFocussedIndex = indexPathForAbsoluteRow(numberOfTotalRows() - 1)
		}
		onFocus?(currentlyFocussedIndex, previouslyFocussedIndex)
	}

	@objc fileprivate func downCommand() {
		guard let previouslyFocussedIndex = currentlyFocussedIndex else {
			currentlyFocussedIndex = indexPathForAbsoluteRow(0)
			onFocus?(currentlyFocussedIndex, nil)
			return
		}

		if (previouslyFocussedIndex as NSIndexPath).row < numberOfRows(inSection: (previouslyFocussedIndex as NSIndexPath).section) - 1 {
			currentlyFocussedIndex = IndexPath(row: (previouslyFocussedIndex as NSIndexPath).row + 1, section: (previouslyFocussedIndex as NSIndexPath).section)
		} else if (previouslyFocussedIndex as NSIndexPath).section < numberOfSections - 1 {
			var section = (previouslyFocussedIndex as NSIndexPath).section + 1
			while section < numberOfSections {
				if numberOfRows(inSection: section) > 0 {
					break
				} else {
					section += 1
				}
			}
			if section < numberOfSections {
				currentlyFocussedIndex = IndexPath(row: 0, section: section)
			} else {
				currentlyFocussedIndex = indexPathForAbsoluteRow(0)
			}
		} else {
			currentlyFocussedIndex = indexPathForAbsoluteRow(0)
		}
		onFocus?(currentlyFocussedIndex, previouslyFocussedIndex)
	}

	@objc fileprivate func returnCommand() {
		guard let currentlyFocussedIndex = currentlyFocussedIndex else { return }
		onSelection?(currentlyFocussedIndex)
	}

	open override func reloadData() {
		onFocus?(currentlyFocussedIndex, nil)
		currentlyFocussedIndex = nil
		super.reloadData()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		NotificationCenter.default.addObserver(self, selector: #selector(KBTableView.escapeCommand), name: NSNotification.Name.UITableViewSelectionDidChange, object: self)
	}

	override public init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		NotificationCenter.default.addObserver(self, selector: #selector(KBTableView.escapeCommand), name: NSNotification.Name.UITableViewSelectionDidChange, object: self)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	open override var canBecomeFirstResponder : Bool {
		return true
	}
    
    open func viewDidLoad() {
        super.layoutSubviews()
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableFooterView = UIView(frame: CGRect.zero)
    }

}

