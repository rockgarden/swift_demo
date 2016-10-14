//
//  Ext_UITableView.swift
//  ExtKIT
//
//  Created by wangkan on 16/6/27.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

public extension UITableView {
    
    public func indexPathForAbsoluteRow(_ absoluteRow: Int) -> IndexPath?{
        var currentRow = 0
        for section in 0..<numberOfSections{
            for row in 0..<numberOfRows(inSection: section){
                if currentRow == absoluteRow{
                    return IndexPath(row: row, section: section)
                }
                currentRow += 1
            }
        }
        return nil
    }
    
    public func absoluteRowForIndexPath(_ indexPath: IndexPath) -> Int?{
        guard (indexPath as NSIndexPath).section < self.numberOfSections else { return nil }
        var rowNumber = 0
        for section in 0..<(indexPath as NSIndexPath).section{
            rowNumber += numberOfRows(inSection: section)
        }
        guard (indexPath as NSIndexPath).row < numberOfRows(inSection: (indexPath as NSIndexPath).section) else { return nil }
        rowNumber += (indexPath as NSIndexPath).row
        return rowNumber
    }
    
    public func numberOfTotalRows() -> Int{
        var total = 0
        for section in 0..<numberOfSections{
            total += numberOfRows(inSection: section)
        }
        return total
    }
    
}

