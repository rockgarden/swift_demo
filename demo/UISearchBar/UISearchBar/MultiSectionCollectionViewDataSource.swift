//
//  MultiSectionCollectionViewDataSource.swift
//  011-Country-Information
//
//  Created by Audrey Li on 4/5/15.
//  Copyright (c) 2015 com.shomigo. All rights reserved.
//


import UIKit


typealias CollectionViewCellConfigureBlock = (_ cell:UICollectionViewCell, _ item:AnyObject?) -> ()

class MultiSectionCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var items: [[AnyObject]]!
    var keys:[String]!
    
    var itemIdentifier:String?
    var configureCellBlock:CollectionViewCellConfigureBlock?
    
    var viewController: AnyObject!
    var segueIdentifier: String!
    
    init(items: [String: [AnyObject]], cellIdentifier: String, viewController: AnyObject, segueIdentifier:String, configureBlock: @escaping CollectionViewCellConfigureBlock) {
        
        self.itemIdentifier = cellIdentifier
        self.viewController = viewController
        self.segueIdentifier = segueIdentifier
        self.configureCellBlock = configureBlock
        
        for (K,V) in items {
            if keys == nil {
                self.items = [V]
                self.keys = [K]
            } else {
                self.keys.append(K)
                self.items.append(V)
            }
        }
        
    }
    
    func updateItems(_ items:[String: [AnyObject]]){
        self.items = nil
        self.keys = nil
        
        for (K,V) in items {
            if keys == nil {
                self.items = [V]
                self.keys = [K]
            } else {
                self.keys.append(K)
                self.items.append(V)
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      // return keys.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemIdentifier!, for: indexPath) as UICollectionViewCell
        let item: AnyObject = self.itemAtIndexPath(indexPath)
        
        if (self.configureCellBlock != nil) {
            self.configureCellBlock!(cell, item)
        }
        
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//        case UICollectionElementKindSectionHeader:
//            
//            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerCell", forIndexPath: indexPath) as HeaderCollectionReusableView
//            headerView.titleLabel.text = keys[indexPath.section]
//            return headerView
//            
//        default:
//            assert(false, "Unexpected element kind")
//        }
//    }
    
    // must config the viewControllerType manually everytime. So far there is no way that I know of to directly get the class name of the object
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = viewController as? GreetingNewViewController {
            vc.dvcData = items[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            vc.performSegue(withIdentifier: segueIdentifier, sender: viewController)
            
        } else {
            print("can not convert view controller")
        }
        
    }
    
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> AnyObject {
        return self.items[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
    }
    
}
