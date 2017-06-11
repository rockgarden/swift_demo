//
//  ViewController.swift
//  DynamicCollectionViewCellWithAutoLayout-Demo
//
//  Created by Honghao Zhang on 2014-09-25.
//  Copyright (c) 2014 HonghaoZ. All rights reserved.
//

import UIKit

class DynamicCellVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    lazy var collectionView: DynamicCellCollectionView = {
        let cv = DynamicCellCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.scrollsToTop = false
        cv.backgroundColor = .lightGray
        return cv
    }()

    let kCellIdentifier = "MyCell"

    let kHorizontalInsets: CGFloat = 10.0
    let kVerticalInsets: CGFloat = 10.0

    var exampleTitle: NSString = "Steve Jobs, BMW & eBay"

    var exampleContent: NSString = "And you know what? He’s right.\nThe world doesn’t need another Dell or HP.  It doesn’t need another manufacturer of plain, beige, boring PCs.  If that’s all we’re going to do, then we should really pack up now.\nBut we’re lucky, because Apple has a purpose.  Unlike anyone in the industry, people want us to make products that they love.  In fact, more than love.  Our job is to make products that people lust for.  That’s what Apple is meant to be.\nWhat’s BMW’s market share of the auto market?  Does anyone know?  Well, it’s less than 2%, but no one cares.  Why?  Because either you drive a BMW or you stare at the new one driving by.  If we do our job, we’ll make products that people lust after, and no one will care about our market share.\nApple is a start-up.  Granted, it’s a startup with $6B in revenue, but that can and will go in an instant.  If you are here for a cushy 9-to-5 job, then that’s OK, but you should go.  We’re going to make sure everyone has stock options, and that they are oriented towards the long term.  If you need a big salary and bonus, then that’s OK, but you should go.  This isn’t going to be that place.  There are plenty of companies like that in the Valley.  This is going to be hard work, possibly the hardest you’ve ever done.  But if we do it right, it’s going to be worth it.\n"

    var numberOfSections = 1
    var numberOfCells = 3
    var titleData = [NSString]()
    var contentData = [NSString]()
    var fontArray = UIFont.familyNames

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cells
        collectionView.dataSource = self
        collectionView.delegate = self
        let myCellNib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: kCellIdentifier)

        for _ in 0..<3 {
            self.addNewOne()
        }
    }

    func addNewOne() {
        var randomNumber1 = Int(arc4random_uniform(UInt32(exampleContent.length)))
        var randomNumber2 = Int(arc4random_uniform(UInt32(exampleContent.length)))
        var text = exampleContent.substring(with: NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2)))
        contentData.append(text as NSString)

        randomNumber1 = Int(arc4random_uniform(UInt32(exampleTitle.length)))
        randomNumber2 = Int(arc4random_uniform(UInt32(exampleTitle.length)))
        text = exampleTitle.substring(with: NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2)))
        titleData.append(text as NSString)
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
        var cell: MyCollectionViewCell = self.collectionView.dequeueReusableOffScreenCellWithReuseIdentifier(reuseIdentifier) as! MyCollectionViewCell

        // Config cell and let system determine size
        cell.configCell(titleData[indexPath.item] as String, content: contentData[indexPath.item] as String, titleFont: fontArray[indexPath.item] as String, contentFont: fontArray[indexPath.item] as String)

        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell.bounds = CGRect(x: 0, y: 0, width: targetWidth, height: cell.bounds.height)
        cell.contentView.bounds = cell.bounds

        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell.setNeedsLayout()
        cell.layoutIfNeeded()

        var size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
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

    @IBAction func add(_ sender: AnyObject) {
        addNewOne()
        _ = self.shuffle(fontArray)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @IBAction func deleteOne(_ sender: AnyObject) {
        if titleData.count > 0 { titleData.removeLast() }
        if contentData.count > 0 { contentData.removeLast() }
        _ = self.shuffle(fontArray)
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


class DynamicCellCollectionView: UICollectionView {
    // A dictionary of offscreen cells that are used within the sizeForItemAtIndexPath method to handle the size calculations. These are never drawn onscreen. The dictionary is in the format:
    // { NSString *reuseIdentifier : UICollectionViewCell *offscreenCell, ... }
    fileprivate var offscreenCells = Dictionary<String, UICollectionViewCell>()
    fileprivate var registeredCellNibs = Dictionary<String, UINib>()
    fileprivate var registeredCellClasses = Dictionary<String, UICollectionViewCell.Type>()

    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        super.register(cellClass, forCellWithReuseIdentifier: identifier)
        registeredCellClasses[identifier] = cellClass as! UICollectionViewCell.Type!
    }

    override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        super.register(nib, forCellWithReuseIdentifier: identifier)
        registeredCellNibs[identifier] = nib
    }

    /**
     Returns a reusable collection cell object located by its identifier.
     This collection cell is not showing on screen, it's useful for calculating dynamic cell size
     - parameter identifier: A string identifying the cell object to be reused. This parameter must not be nil.

     - returns: UICollectionViewCell?
     */
    func dequeueReusableOffScreenCellWithReuseIdentifier(_ identifier: String) -> UICollectionViewCell? {
        var cell: UICollectionViewCell? = offscreenCells[identifier]
        if cell == nil {
            if registeredCellNibs.index(forKey: identifier) != nil {
                let cellNib: UINib = registeredCellNibs[identifier]! as UINib
                cell = cellNib.instantiate(withOwner: nil, options: nil)[0] as? UICollectionViewCell
            } else if registeredCellClasses.index(forKey: identifier) != nil {
                let cellClass = registeredCellClasses[identifier] as UICollectionViewCell.Type!
                cell = cellClass?.init()
            } else {
                assertionFailure("\(identifier) is not registered in \(self)")
            }
            offscreenCells[identifier] = cell
        }
        return cell
    }
}

