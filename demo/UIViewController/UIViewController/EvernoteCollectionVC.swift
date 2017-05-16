//
//  CollectionViewController.swift
//  evernote
//
//  Created by 梁树元 on 10/12/15.
//  Copyright © 2015 com. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EvernoteCell"
private let topPadding:CGFloat = 64
public let BGColor = UIColor(red: 56.0/255.0, green: 51/255.0, blue: 76/255.0, alpha: 1.0)

class EvernoteCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    fileprivate let colorArray = NSMutableArray()
    fileprivate let rowNumber = 15
    fileprivate let customTransition = EvernoteTransition()
    fileprivate let collectionView = UICollectionView(frame: CGRect(x: 0, y: topPadding, width: screenWidth, height: screenHeight - topPadding), collectionViewLayout: CollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BGColor
        collectionView.backgroundColor = BGColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, verticallyPadding, 0);

        self.view.addSubview(collectionView)
        let nib = UINib(nibName: "EvernoteCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let random = arc4random() % 360 // 160 arc4random() % 360
        for index in 0 ..< rowNumber{
            let color = UIColor(hue: CGFloat((Int(random) + index * 6)).truncatingRemainder(dividingBy: 360.0) / 360.0, saturation: 0.8, brightness: 1.0, alpha: 1.0)
            colorArray.add(color)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EvernoteCell
        cell.backgroundColor = colorArray.object(at: colorArray.count - 1 - indexPath.section) as? UIColor
        cell.titleLabel.text = "Notebook + " + String(indexPath.section + 1)
        cell.titleLine.alpha = 0.0
        cell.textView.alpha = 0.0
        cell.backButton.alpha = 0.0
        cell.tag = indexPath.section
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EvernoteCell
        let visibleCells = collectionView.visibleCells as! [EvernoteCell]
        let storyBoard = UIStoryboard(name: "evernote", bundle: nil)
        let v = storyBoard.instantiateViewController(withIdentifier: "Note") as! NoteViewController
        v.titleName = cell.titleLabel.text!
        v.domainColor = cell.backgroundColor!

        let finalFrame = CGRect(x: 10, y: collectionView.contentOffset.y + 10, width: screenWidth - 20, height: screenHeight - 40)
        self.customTransition.EvernoteTransitionWith(selectCell: cell, visibleCells: visibleCells, originFrame: cell.frame, finalFrame: finalFrame, panViewController:v, listViewController: self)
        v.transitioningDelegate = self.customTransition
        v.delegate = self.customTransition
        self.present(v, animated: true) { () -> Void in
        }
    }

}


public let horizonallyPadding:CGFloat = 10
public let verticallyPadding:CGFloat = 10
public let cellWidth = screenWidth - 2 * horizonallyPadding
private let cellHeight:CGFloat = 45
private let SpringFactor:CGFloat = 10.0

class CollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        headerReferenceSize = CGSize(width: screenWidth, height: verticallyPadding)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        headerReferenceSize = CGSize(width: screenWidth, height: verticallyPadding)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let offsetY = self.collectionView!.contentOffset.y
        let attrsArray = super.layoutAttributesForElements(in: rect)
        let collectionViewFrameHeight = self.collectionView!.frame.size.height;
        let collectionViewContentHeight = self.collectionView!.contentSize.height;
        let ScrollViewContentInsetBottom = self.collectionView!.contentInset.bottom;
        let bottomOffset = offsetY + collectionViewFrameHeight - collectionViewContentHeight - ScrollViewContentInsetBottom
        let numOfItems = self.collectionView!.numberOfSections
        
        for attr:UICollectionViewLayoutAttributes in attrsArray! {
            if (attr.representedElementCategory == UICollectionElementCategory.cell) {
                var cellRect = attr.frame;
                if offsetY <= 0 {
                    let distance = fabs(offsetY) / SpringFactor;
                    //通过变换每个cell的起始y坐标
                    cellRect.origin.y += offsetY + distance * CGFloat(attr.indexPath.section + 1);
                }else if bottomOffset > 0 {
                    let distance = bottomOffset / SpringFactor;
                    cellRect.origin.y += bottomOffset - distance *
                        CGFloat(numOfItems - attr.indexPath.section)
                }
                attr.frame = cellRect;
            }
        }
        return attrsArray;
    }
}


class EvernoteCell: UICollectionViewCell {
    
    @IBOutlet internal weak var backButton: UIButton!
    @IBOutlet internal weak var titleLine: UIView!
    @IBOutlet internal weak var textView: UITextView!
    @IBOutlet internal weak var titleLabel: UILabel!
    @IBOutlet internal weak var labelLeadCons: NSLayoutConstraint!
    internal var horizonallyCons = NSLayoutConstraint()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.horizonallyCons = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
    }
    
}
