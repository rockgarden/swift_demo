//
//  UIFontFamilyVC.swift
//  UICollectionView
//
//  Created by wangkan on 2017/4/25.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class UIFontFamilyVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // FlowLayout
    lazy fileprivate var flowLayout: UICollectionViewFlowLayout? = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 10
        fl.minimumInteritemSpacing = 0
        fl.scrollDirection = .vertical
        fl.minimumInteritemSpacing = 0
        fl.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        fl.sectionFootersPinToVisibleBounds = false
        return fl
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout!)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.scrollsToTop = false
        cv.backgroundColor = UIColor.lightGray
        return cv
    }()
    
    let kCellIdentifier = "FontCell"
    
    let kHorizontalInsets: CGFloat = 10.0
    let kVerticalInsets: CGFloat = 10.0
    
    var exampleTitle = "字体名称"
    
    var exampleContent = "Are you ok? 你好吗? \n I’m right. 我很好.\n."
    
    var numberOfSections = 1
    var numberOfCells = 3
    var titleData = UIFont.familyNames
    var contentData = [String]()
    var fontArray = UIFont.familyNames
    
    /// A dictionary of offscreen cells that are used within the sizeForItemAtIndexPath method to handle the size calculations. These are never drawn onscreen.
    var offscreenCells = Dictionary<String, UICollectionViewCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        let views = ["cv":collectionView] as [String:Any]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[cv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(0)-[cv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map { $0 })
        
        collectionView.register(UIFontCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        for _ in titleData {
            contentData.append(exampleContent)
        }
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! UIFontCell
        
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
        var cell = offscreenCells[reuseIdentifier] as? UIFontCell
        if cell == nil {
            cell = UIFontCell()
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


class UIFontCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    let kLabelVerticalInsets: CGFloat = 8.0
    let kLabelHorizontalInsets: CGFloat = 8.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        if floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_7_1 {
            /// Need set autoresizingMask to let contentView always occupy this view's bounds, key for iOS7
            self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }

        layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    fileprivate func setupViews() {
        isSelected = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["tl":titleLabel, "cl":contentLabel] as [String : Any]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[tl]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(0)-[tl(>=40)]", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[cl]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[tl]-[cl]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map { $0 })
    }
    
    // In layoutSubViews, need set preferredMaxLayoutWidth for multiple lines label
    override func layoutSubviews() {
        super.layoutSubviews()
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
