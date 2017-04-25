//
//  UIFontFamilyVC.swift
//  UICollectionView
//
//  Created by wangkan on 2017/4/25.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class UIFontFamilyVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var collectionView: UICollectionView!
    
    let kCellIdentifier = "FontCell"
    
    let kHorizontalInsets: CGFloat = 10.0
    let kVerticalInsets: CGFloat = 10.0
    
    var exampleTitle = "字体名称"
    
    var exampleContent = "Are you ok? 你好吗? He’s right.\n The world doesn’t need another Dell or HP.  It doesn’t need another manufacturer of plain, beige, boring PCs.  If that’s all we’re going to do, then we should really pack up now.\n."
    
    var numberOfSections = 1
    var numberOfCells = 3
    var titleData = UIFont.familyNames
    var contentData = [String]()
    var fontArray = UIFont.familyNames
    
    /// A dictionary of offscreen cells that are used within the sizeForItemAtIndexPath method to handle the size calculations. These are never drawn onscreen.
    var offscreenCells = Dictionary<String, UICollectionViewCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let myCellNib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: kCellIdentifier)
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! MyCollectionViewCell
        
        cell.configCell(titleData[indexPath.item] as String, content: contentData[indexPath.item] as String, titleFont: fontArray[indexPath.item] as String, contentFont: fontArray[indexPath.item] as String)
        
        // Make sure layout subviews
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UICollectionViewFlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set up desired width
        let targetWidth: CGFloat = (self.collectionView.bounds.width - 3 * kHorizontalInsets) / 2
        
        // Use fake cell to calculate height
        let reuseIdentifier = kCellIdentifier
        var cell = offscreenCells[reuseIdentifier] as? MyCollectionViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MyCollectionViewCell", owner: self, options: nil)?[0] as? MyCollectionViewCell
            self.offscreenCells[reuseIdentifier] = cell
        }
        
        // Config cell and let system determine size
        cell!.configCell(titleData[indexPath.item] as String, content: contentData[indexPath.item] as String, titleFont: fontArray[indexPath.item] as String, contentFont: fontArray[indexPath.item] as String)
        
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell!.bounds = CGRect(x: 0, y: 0, width: targetWidth, height: cell!.bounds.height)
        cell!.contentView.bounds = cell!.bounds
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell!.setNeedsLayout()
        cell!.layoutIfNeeded()
        
        var size = cell!.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kVerticalInsets, kHorizontalInsets, kVerticalInsets, kHorizontalInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kHorizontalInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kVerticalInsets
    }
    
    func shuffle<T>(_ list: Array<T>) -> Array<T> {
        var list = list
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.remove(at: j), at: i)
        }
        return list
    }
    
    // Adds a new cell
    @IBAction func add(_ sender: AnyObject) {
        addNewOne()
        self.shuffle(fontArray)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    // Deletes a cell
    @IBAction func deleteOne(_ sender: AnyObject) {
        if titleData.count > 0 { titleData.removeLast() }
        if contentData.count > 0 { contentData.removeLast() }
        self.shuffle(fontArray)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Rotation
    // iOS7
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // iOS8
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}


// Check System Version
let isIOS7: Bool = !isIOS8
let isIOS8: Bool = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1

class MyCollectionViewCell: UICollectionViewCell {
    
    weak var titleLabel: UILabel!
    weak var contentLabel: UILabel!
    
    let kLabelVerticalInsets: CGFloat = 8.0
    let kLabelHorizontalInsets: CGFloat = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if isIOS7 {
            // Need set autoresizingMask to let contentView always occupy this view's bounds, key for iOS7
            self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        self.layer.masksToBounds = true
    }
    
    // In layoutSubViews, need set preferredMaxLayoutWidth for multiple lines label
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set what preferredMaxLayoutWidth you want
        contentLabel.preferredMaxLayoutWidth = self.bounds.width - 2 * kLabelHorizontalInsets
    }
    
    func configCell(_ title: String, content: String, titleFont: String, contentFont: String) {
        titleLabel.text = title
        contentLabel.text = content
        
        titleLabel.font = UIFont(name: titleFont, size: 18)
        contentLabel.font = UIFont(name: contentFont, size: 16)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
