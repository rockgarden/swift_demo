//
//  RJExpandableTableView.swift
//  RJExpandableTableView
//
//  Created by 吴蕾君 on 16/5/12.
//  Copyright © 2016年 rayjuneWu. All rights reserved.
//
//  Modified by wangkan on 16/9/10
//

import UIKit

public protocol RJExpandableTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: RJExpandableTableView, canExpandInSection section: Int) -> Bool
    func tableView(_ tableView: RJExpandableTableView, expandingCellForSection section: Int) -> RJExpandingTableViewCell
    func tableView(_ tableView: RJExpandableTableView, needsToDownloadDataForExpandSection section: Int) -> Bool
}

public protocol RJExpandableTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: RJExpandableTableView, downloadDataForExpandableSection section: Int)
    // Optional for Expanding Cell height
    func tableView(_ tableView: RJExpandableTableView, heightForExpandingCellAtSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

// MARK: - RJExpandableTableView main class
open class RJExpandableTableView: UITableView {

    lazy var canExpandedSections = [Int]()
    lazy var expandedSections = [Int]()
    lazy var downloadingSections = [Int]()
    open var keepExpanded = true // 开关参数:是否收缩已经展开的section

    override weak open var delegate: UITableViewDelegate? {
        get {
            return super.delegate
        }
        set {
            super.delegate = self
            expandDelegate = newValue as? RJExpandableTableViewDelegate
        }
    }

    override weak open var dataSource: UITableViewDataSource? {
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

    fileprivate weak var expandDataSource: RJExpandableTableViewDataSource!
    fileprivate weak var expandDelegate: RJExpandableTableViewDelegate!

    // MARK: Public
    /**
     Operation to expand a section.

     - parameter section:  expanded section
     - parameter animated: animate or not
     */
    open func expandSection(_ section: Int, animated: Bool) {
        guard !expandedSections.contains(section) else {
            return
        }
        if let downloadingIndex = downloadingSections.index(of: section) {
            downloadingSections.remove(at: downloadingIndex)
        }
        deselectRow(at: IndexPath(row: 0, section: section), animated: true)
        if keepExpanded { expandedSections.removeAll() }
        expandedSections.append(section)
        reloadData()
    }

    /**
     Operation to collapse a section

     - parameter section:  collapsed section
     - parameter animated: animate or not
     */
    open func collapseSection(_ section: Int, animated: Bool) {
        if let index = expandedSections.index(of: section) {
            expandedSections.remove(at: index)
        }
        reloadData()
    }

    /**
     Operation to cancel download in a section.

     - parameter section: downloading section
     */
    open func cancelDownloadInSection(_ section: Int) {
        guard let index = downloadingSections.index(of: section) else {
            return
        }
        downloadingSections.remove(at: index)
        reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
    }

    // Check a section is expandable or not
    open func canExpandSection(_ section: Int) -> Bool {
        return canExpandedSections.contains(section)
    }

    // Check a section is expanding or not
    open func isSectionExpand(_ section: Int) -> Bool {
        return expandedSections.contains(section)
    }

    // MARK: Private Helper
    fileprivate func canExpand(_ section: Int) -> Bool {
        return expandDataSource.tableView(self, canExpandInSection: section)
    }
    fileprivate func needsToDownload(_ section: Int) -> Bool {
        return expandDataSource.tableView(self, needsToDownloadDataForExpandSection: section)
    }
    fileprivate func downloadData(inSection section: Int) {
        downloadingSections.append(section)
        expandDelegate.tableView(self, downloadDataForExpandableSection: section)
        reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
    }
}

// MARK: TableView DataSource
extension RJExpandableTableView: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        if expandDataSource.responds(to: #selector(UITableViewDataSource.numberOfSections(in:))) {
            return expandDataSource.numberOfSections!(in: tableView)
        }
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if canExpand(section) {
            if indexPath.row == 0 {
                let expandCell = expandDataSource.tableView(self, expandingCellForSection: section)
                if downloadingSections.contains(section) {
                    expandCell.setLoading(true)
                } else {
                    expandCell.setLoading(false)
                    if (expandedSections.contains(section)) {
                        expandCell.setExpandStatus(RJExpandStatus.expanded, animated: false)
                    } else {
                        expandCell.setExpandStatus(RJExpandStatus.collapsed, animated: false)
                    }
                }
                return expandCell as! UITableViewCell
            } else {
                return expandDataSource.tableView(self, cellForRowAt: indexPath)
            }
        } else {
            return expandDataSource.tableView(self, cellForRowAt: indexPath)
        }
    }

}

// MARK: TableView Delegate
extension RJExpandableTableView: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return expandDelegate.tableView(self, heightForExpandingCellAtSection: indexPath.section)
        } else {
            return expandDelegate.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            } else {
                return expandDelegate.tableView!(tableView, didSelectRowAt: indexPath)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        return expandDelegate.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        return expandDelegate.tableView!(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    //    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    //        if tableView.indexPathForSelectedRow == indexPath {
    //            tableView.deselectRowAtIndexPath(indexPath, animated:false)
    //            return nil
    //        }
    //        return indexPath
    //    }
    
}
