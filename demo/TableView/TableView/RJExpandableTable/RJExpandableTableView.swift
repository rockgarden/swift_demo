//
//  RJExpandableTableView.swift
//  RJExpandableTableView
//
//  Created by 吴蕾君 on 16/5/12.
//  Copyright © 2016年 rayjuneWu. All rights reserved.
//

import UIKit

public protocol RJExpandableTableViewDataSource: UITableViewDataSource {
    func tableView(tableView: RJExpandableTableView, canExpandInSection section: Int) -> Bool
    func tableView(tableView: RJExpandableTableView, expandingCellForSection section: Int) -> RJExpandingTableViewCell
    func tableView(tableView: RJExpandableTableView, needsToDownloadDataForExpandSection section: Int) -> Bool
}

public protocol RJExpandableTableViewDelegate: UITableViewDelegate {
    func tableView(tableView: RJExpandableTableView, downloadDataForExpandableSection section: Int)
    // Optional for Expanding Cell height
    func tableView(tableView: RJExpandableTableView, heightForExpandingCellAtSection section: Int) -> CGFloat
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

// MARK: - RJExpandableTableViewDelegate default value
extension RJExpandableTableViewDelegate {
    
    func tableView(tableView: RJExpandableTableView, heightForExpandingCellAtSection section: Int) -> CGFloat {
        return 44
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
}

// MARK: - RJExpandableTableView main class
public class RJExpandableTableView: UITableView {
    
    lazy var canExpandedSections = [Int]()
    lazy var expandedSections = [Int]()
    lazy var downloadingSections = [Int]()
    
    override weak public var delegate: UITableViewDelegate? {
        get {
            return super.delegate
        }
        set {
            super.delegate = self
            expandDelegate = newValue as? RJExpandableTableViewDelegate
        }
    }
    
    override weak public var dataSource: UITableViewDataSource? {
        get {
            return super.dataSource
        }
        set {
            super.dataSource = self
            guard newValue is RJExpandableTableViewDataSource else {
                fatalError("Must has a datasource conforms to protocol 'RJExpandableTableViewDataSource'")
            }
            expandDataSource = newValue as! RJExpandableTableViewDataSource
        }
    }
    
    private weak var expandDataSource: RJExpandableTableViewDataSource!
    private weak var expandDelegate: RJExpandableTableViewDelegate!
    
    // MARK: Public
    
    /**
     Operation to expand a section.
     
     - parameter section:  expanded section
     - parameter animated: animate or not
     */
    public func expandSection(section: Int, animated: Bool) {
        guard !expandedSections.contains(section) else {
            return
        }
        if let downloadingIndex = downloadingSections.indexOf(section) {
            downloadingSections.removeAtIndex(downloadingIndex)
        }
        deselectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section), animated: false)
        expandedSections.append(section)
        reloadData()
    }
    
    /**
     Operation to collapse a section
     
     - parameter section:  collapsed section
     - parameter animated: animate or not
     */
    public func collapseSection(section: Int, animated: Bool) {
        if let index = expandedSections.indexOf(section) {
            expandedSections.removeAtIndex(index)
        }
        reloadData()
    }
    
    /**
     Operation to cancel download in a section.
     
     - parameter section: downloading section
     */
    public func cancelDownloadInSection(section: Int) {
        guard let index = downloadingSections.indexOf(section) else {
            return
        }
        downloadingSections.removeAtIndex(index)
        reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: section)], withRowAnimation: .Automatic)
    }
    
    /**
     Check a section is expandable or not
     
     - parameter section: The section
     
     - returns: Bool
     */
    public func canExpandSection(section: Int) -> Bool {
        return canExpandedSections.contains(section)
    }
    
    /**
     Check a section is expanding or not
     
     - parameter section: The section
     
     - returns: Bool
     */
    public func isSectionExpand(section: Int) -> Bool {
        return expandedSections.contains(section)
    }
    
    // MARK: Private Helper
    private func canExpand(section: Int) -> Bool {
        return expandDataSource.tableView(self, canExpandInSection: section)
    }
    private func needsToDownload(section: Int) -> Bool {
        return expandDataSource.tableView(self, needsToDownloadDataForExpandSection: section)
    }
    private func downloadData(inSection section: Int) {
        downloadingSections.append(section)
        expandDelegate?.tableView(self, downloadDataForExpandableSection: section)
        reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: section)], withRowAnimation: .Automatic)
    }
}

// MARK: TableView DataSource
extension RJExpandableTableView: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if expandDataSource.respondsToSelector(#selector(UITableViewDataSource.numberOfSectionsInTableView(_:))) {
            return expandDataSource.numberOfSectionsInTableView!(tableView)
        }
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if canExpand(section) {
            canExpandedSections.append(section)
            if expandedSections.contains(section) {
                return expandDataSource.tableView(self, numberOfRowsInSection: section) + 1
            } else {
                return 1
            }
            
        } else {
            return expandDataSource.tableView(self, numberOfRowsInSection: section)
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if canExpand(section) {
            if indexPath.row == 0 {
                
                let expandCell = expandDataSource.tableView(self, expandingCellForSection: section)
                
                if downloadingSections.contains(section) {
                    expandCell.setLoading(true)
                } else {
                    expandCell.setLoading(false)
                    if (expandedSections.contains(section)) {
                        expandCell.setExpandStatus(RJExpandStatus.Expanded, animated: false)
                    } else {
                        expandCell.setExpandStatus(RJExpandStatus.Collapsed, animated: false)
                    }
                }
                return expandCell as! UITableViewCell
                
            } else {
                return expandDataSource.tableView(self, cellForRowAtIndexPath: indexPath)
            }
        } else {
            return expandDataSource.tableView(self, cellForRowAtIndexPath: indexPath)
        }
    }
    
}

// MARK: TableView Delegate
extension RJExpandableTableView: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return expandDelegate.tableView(self, heightForExpandingCellAtSection: indexPath.section)
        } else {
            return expandDelegate.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        if canExpand(section) {
            if indexPath.row == 0 {
                if expandedSections.contains(section) {
                    collapseSection(section, animated: true)
                } else {
                    if needsToDownload(section) {
                        downloadData(inSection: section)
                    } else {
                        expandSection(section, animated: true)
                    }
                }
            }
        }
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        return expandDelegate.tableView!(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }

}