//
//  PhotoManagerView.swift
//  mobile112
//
//  Created by wangkan on 2016/12/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import Photos

@objc public protocol FunctionCollectionViewDelegate: class { }

typealias didSelectItemClosure_FCV = (_ index: Int)->Void

final class FunctionCollectionView: UIView {

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout!)
        cv.register(FunctionCell.self, forCellWithReuseIdentifier: functionCellReuseId)
        cv.register(FunctionSectionHeader.self,
                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                    withReuseIdentifier: functionSectionHeaderReuseId)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.scrollsToTop = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    // FlowLayout
    lazy fileprivate var flowLayout: UICollectionViewFlowLayout? = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 0
        fl.minimumInteritemSpacing = 0
        fl.scrollDirection = .vertical
        fl.minimumInteritemSpacing = 0
        fl.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        fl.sectionFootersPinToVisibleBounds = false
        return fl
    }()

    weak var delegate: FunctionCollectionViewDelegate? = nil

    fileprivate var dataSource = FunctionDataSource()

    // 回调
    var didSelectItemClosure: didSelectItemClosure_FCV?
    
    // MARK: Init
    convenience init(didSelectItemAtIndex: didSelectItemClosure_FCV? = nil) {
        self.init()
        if didSelectItemAtIndex != nil {
            didSelectItemClosure = didSelectItemAtIndex
        }
        initialize()
    }

    fileprivate func initialize() {
        addSubview(collectionView)
        let views = ["cv" : collectionView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[cv]-0-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cv]-0-|", options: [], metrics: nil, views: views))
    }
    
    /// 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width / 4
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.headerReferenceSize = CGSize(width: width, height: 0)
    }

}


// MARK: UICollectionViewDelegate
extension FunctionCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: functionSectionHeaderReuseId, for: indexPath) as! FunctionSectionHeader
        if let title = dataSource.titleForSectionAtIndexPath(indexPath) {
            sectionHeader.title = title
            sectionHeader.icon = #imageLiteral(resourceName: "c_icon")
        }
        return sectionHeader
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: functionCellReuseId, for: indexPath) as! FunctionCell
        // Configure the cell
        if let function = dataSource.functionForItemAtIndexPath(indexPath) {
            cell.function = function
        }
        // Configure the cell Tag
        let currentTag = cell.tag + 1
        cell.tag = currentTag
        return cell
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.frame.width/4, height: self.frame.width/4)
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    
}


// MARK: - DataSource
private class FunctionDataSource {
    
    fileprivate var functions: [Function] = []
    fileprivate var immutableFunctions: [Function] = []
    fileprivate var sections: [String] = [] //相当于types
    
    var count: Int {
        return functions.count
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    // MARK: Public
    
    init() {
        functions = loadPapersFromDisk()
        immutableFunctions = functions
    }
    
    func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
        var indexes: [Int] = []
        for indexPath in indexPaths {
            indexes.append(absoluteIndexForIndexPath(indexPath))
        }
        var newFunctions: [Function] = []
        for (index, f) in functions.enumerated() {
            if !indexes.contains(index) {
                newFunctions.append(f)
            }
        }
        functions = newFunctions
    }
    
    func indexPathForNewRandomItem() -> IndexPath {
        let index = Int(arc4random_uniform(UInt32(immutableFunctions.count)))
        let item = immutableFunctions[index]
        let f = Function(copying: item)
        functions.append(f)
        functions.sort { $0.index < $1.index }
        return indexPathForItem(f)
    }
    
    func indexPathForItem(_ function: Function) -> IndexPath {
        let section = sections.index(of: function.type)!
        var item = 0
        for (index, currentFunction) in itemsForSection(section).enumerated() {
            if currentFunction === function {
                item = index
                break
            }
        }
        return IndexPath(item: item, section: section)
    }
    
    func moveItemAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
        if indexPath == newIndexPath {
            return
        }
        let index = absoluteIndexForIndexPath(indexPath)
        let f = functions[index]
        f.type = sections[newIndexPath.section]
        let newIndex = absoluteIndexForIndexPath(newIndexPath)
        functions.remove(at: index)
        functions.insert(f, at: newIndex)
    }
    
    func numberOfItemsInSection(_ index: Int) -> Int {
        let fs = itemsForSection(index)
        return fs.count
    }
    
    func titleForSectionAtIndexPath(_ indexPath: IndexPath) -> String? {
        if indexPath.section < sections.count {
            return sections[indexPath.section]
        }
        return nil
    }
    
    func functionForItemAtIndexPath(_ indexPath: IndexPath) -> Function? {
        if indexPath.section > 0 {
            let functions = itemsForSection(indexPath.section)
            return functions[indexPath.item]
        } else {
            return functions[indexPath.item]
        }
    }
    
    // MARK: Private
    
    fileprivate func absoluteIndexForIndexPath(_ indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<indexPath.section {
            index += numberOfItemsInSection(i)
        }
        index += indexPath.item
        return index
    }
    
    fileprivate func loadPapersFromDisk() -> [Function] {
        sections.removeAll(keepingCapacity: false)
        if let path = Bundle.main.path(forResource: "Functions", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                var fs: [Function] = []
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let name = dict["name"] as! String
                        let iconName = dict["imageName"] as! String
                        let type = dict["section"] as! String
                        let index = dict["index"] as! Int
                        let f = Function(name: name, iconName: iconName, type: type, index: index)
                        if !sections.contains(type) {
                            sections.append(type)
                        }
                        fs.append(f)
                    }
                }
                return fs
            }
        }
        return []
    }
    
    fileprivate func itemsForSection(_ index: Int) -> [Function] {
        let section = sections[index]
        let itemsInSection = functions.filter { (f: Function) -> Bool in
            return f.type == section
        }
        return itemsInSection
    }
    
}

