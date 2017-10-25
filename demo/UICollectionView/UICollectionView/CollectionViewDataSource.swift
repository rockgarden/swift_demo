//
//  CollectionViewDataSource.swift
//  示例自定义UICollectionViewDataSource
//

//dataSource = CollectionViewDataSource(items: Array, cellIdentifier: String, configureBlock: { (cell, item) -> () in
//    if let actualCell = cell as? CollectionViewCell {
//        actualCell.configureForItem(item!)
//    }
//})



import UIKit

typealias CollectionViewCellConfigureBlock = (_ cell:UICollectionViewCell, _ item: AnyObject?) -> ()

class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var items: Array = [Any]()
    var itemIdentifier:String?
    var configureCellBlock:CollectionViewCellConfigureBlock?
    
    init(items: Array<Any>, cellIdentifier: String, configureBlock: @escaping CollectionViewCellConfigureBlock) {
        self.items = items
        self.itemIdentifier = cellIdentifier
        self.configureCellBlock = configureBlock
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.itemIdentifier!, for: indexPath) as UICollectionViewCell
        let item: AnyObject = self.itemAtIndexPath(indexPath)
        
        if (self.configureCellBlock != nil) {
            self.configureCellBlock!(cell, item)
        }
        
        return cell
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> AnyObject {
        return self.items[indexPath.row] as AnyObject
    }
}
