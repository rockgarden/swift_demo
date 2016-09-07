//
//  RJExpandableTableViewCell.swift
//  RJExpandableTableView
//
//  Created by 吴蕾君 on 16/5/12.
//  Copyright © 2016年 rayjuneWu. All rights reserved.
//

import Foundation

/**
 Expand Status
 
 - Collapsed: The cell is collapsed
 - Expanded:  The cell is expanded
 */
public enum RJExpandStatus {
    case Collapsed, Expanded
}

public protocol RJExpandingTableViewCell {
    /**
     When the loading status changes,RJExpandableTabelView will call this method.
     You can implement it to do some things.
     - parameter loading: Is data loading
     */
    func setLoading(loading: Bool)
    /**
     When the section expand status changes,RJExpandableTableView will call this method.
     You can implement it to do some things, like animate the arrow image etc.
     - parameter status:   Expanded or Collapsed
     - parameter animated: Animated or not
     */
    func setExpandStatus(status: RJExpandStatus, animated: Bool)
}