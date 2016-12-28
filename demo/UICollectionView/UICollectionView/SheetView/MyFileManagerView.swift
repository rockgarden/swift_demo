//
//  MyFileManagerView.swift
//  mobile112
//
//  Created by wangkan on 2016/12/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import Photos

public let NumberOfItemsOneRow: CGFloat = 4
public let FileViewCellSize = (UIScreen.main.bounds.width - NumberOfItemsOneRow - 1) / NumberOfItemsOneRow
public let FileManagerViewHeight = FileViewCellSize

@objc public protocol MyFileManagerViewDelegate: class {
    func cameraRollUnauthorized()
    func presentCamera()
}

final class MyFileManagerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: MyFileManagerViewDelegate? = nil
    var isPrivate: Bool!

    var images: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager?
    var phAsset: PHAsset!
    var previousPreheatRect: CGRect = CGRect.zero
    let cellSize = CGSize(width: FileViewCellSize, height: FileViewCellSize)

    static func instance() -> MyFileManagerView {
        return UINib(nibName: "MyFileManagerView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MyFileManagerView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    func initialize() {
        let flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        setUpFlowLayout(flow)

        debugPrint("collectionView",collectionView)

        collectionView.backgroundColor = UIColor.clear
        //Bundle(for: self.classForCoder) = nil
        collectionView.register(UINib(nibName: "MyFileViewCell", bundle: nil), forCellWithReuseIdentifier: "MyFileViewCell")
        collectionView.register(UINib(nibName: "CameraViewCell", bundle: nil),
                                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter,
                                withReuseIdentifier:"Footer")

        // Never load photos Unless the user allows to access to photo album
        checkPhotoAuth()

        // Sorting condition
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        images = PHAsset.fetchAssets(with: .image, options: options)

        if images.count > 0 {
            changeImage(images[0])
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
        }

        PHPhotoLibrary.shared().register(self)
    }

    fileprivate func setUpFlowLayout(_ flow:UICollectionViewFlowLayout) {
        flow.footerReferenceSize = cellSize
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0) // looks nicer
        flow.sectionFootersPinToVisibleBounds = false // try cool new iOS 9 feature
        flow.scrollDirection = .horizontal

        // uncomment to crash
        // cripes, now we don't crash, but the layout is wrong! can these guys never get this implemented???
        // also tried doing this by overriding sizeThatFits in the cell, but with the same wrong layout
        // also tried doing it by overriding preferredAttributes in the cell, same wrong layout
        // flow.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
    }


    deinit {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            PHPhotoLibrary.shared().unregisterChangeObserver(self)
        }
    }


    // MARK: - UICollectionViewDelegate Protocol

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionFooter {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier:"Footer", for: indexPath) as! CameraViewCell
        }
        return v
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFileViewCell", for: indexPath) as! MyFileViewCell

        let currentTag = cell.tag + 1
        cell.tag = currentTag

        let asset = self.images[indexPath.item]
        self.imageManager?.requestImage(for: asset,
                                        targetSize: cellSize,
                                        contentMode: .aspectFill,
                                        options: nil) {
                                            result, info in
                                            if cell.tag == currentTag {
                                                cell.image = result
                                            }

        }
        return cell

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images == nil ? 0 : images.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: FileViewCellSize, height: FileViewCellSize)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeImage(images[indexPath.row])
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }


    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            self.updateCachedAssets()
        }
    }


    //MARK: - PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(_ changeInstance: PHChange) {

        DispatchQueue.main.async {

            let collectionChanges = changeInstance.changeDetails(for: self.images)
            if collectionChanges != nil {

                self.images = collectionChanges!.fetchResultAfterChanges

                let collectionView = self.collectionView!

                if !collectionChanges!.hasIncrementalChanges || collectionChanges!.hasMoves {
                    collectionView.reloadData()
                } else {
                    collectionView.performBatchUpdates({
                        let removedIndexes = collectionChanges!.removedIndexes
                        if (removedIndexes?.count ?? 0) != 0 {
                            collectionView.deleteItems(at: removedIndexes!.aapl_indexPathsFromIndexesWithSection(0))
                        }
                        let insertedIndexes = collectionChanges!.insertedIndexes
                        if (insertedIndexes?.count ?? 0) != 0 {
                            collectionView.insertItems(at: insertedIndexes!.aapl_indexPathsFromIndexesWithSection(0))
                        }
                        let changedIndexes = collectionChanges!.changedIndexes
                        if (changedIndexes?.count ?? 0) != 0 {
                            collectionView.reloadItems(at: changedIndexes!.aapl_indexPathsFromIndexesWithSection(0))
                        }
                    }, completion: nil)
                }
                self.resetCachedAssets()
            }
        }
    }
}


internal extension UICollectionView {

    func aapl_indexPathsForElementsInRect(_ rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = self.collectionViewLayout.layoutAttributesForElements(in: rect)
        if (allLayoutAttributes?.count ?? 0) == 0 {return []}
        var indexPaths: [IndexPath] = []
        indexPaths.reserveCapacity(allLayoutAttributes!.count)
        for layoutAttributes in allLayoutAttributes! {
            let indexPath = layoutAttributes.indexPath
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
}

internal extension IndexSet {

    func aapl_indexPathsFromIndexesWithSection(_ section: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        indexPaths.reserveCapacity(self.count)
        (self as NSIndexSet).enumerate({idx, stop in
            indexPaths.append(IndexPath(item: idx, section: section))
        })
        return indexPaths
    }
}

private extension MyFileManagerView {

    func changeImage(_ asset: PHAsset) {
        self.phAsset = asset

        DispatchQueue.global(qos: .default).async(execute: {
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true

            self.imageManager?.requestImage(for: asset,
                                            targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                            contentMode: .aspectFill,
                                            options: options) {
                                                result, info in
                                                DispatchQueue.main.async(execute: {
                                                })
            }
        })
    }

    // Check the status of authorization for PHPhotoLibrary
    func checkPhotoAuth() {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status {
            case .authorized:
                self.imageManager = PHCachingImageManager()
                if self.images != nil && self.images.count > 0 {

                    self.changeImage(self.images[0])
                }
            case .restricted, .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.cameraRollUnauthorized()
                })
            default:
                break
            }
        }
    }

    @IBAction func startCamera() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.presentCamera()
        })
    }

    // MARK: - Asset Caching

    func resetCachedAssets() {
        imageManager?.stopCachingImagesForAllAssets()
        previousPreheatRect = CGRect.zero
    }

    func updateCachedAssets() {

        var preheatRect = self.collectionView!.bounds
        preheatRect = preheatRect.insetBy(dx: 0.0, dy: -0.5 * preheatRect.height)

        let delta = abs(preheatRect.midY - self.previousPreheatRect.midY)
        if delta > self.collectionView!.bounds.height / 3.0 {

            var addedIndexPaths: [IndexPath] = []
            var removedIndexPaths: [IndexPath] = []

            self.computeDifferenceBetweenRect(self.previousPreheatRect, andRect: preheatRect, removedHandler: {removedRect in
                let indexPaths = self.collectionView.aapl_indexPathsForElementsInRect(removedRect)
                removedIndexPaths += indexPaths
            }, addedHandler: {addedRect in
                let indexPaths = self.collectionView.aapl_indexPathsForElementsInRect(addedRect)
                addedIndexPaths += indexPaths
            })

            let assetsToStartCaching = self.assetsAtIndexPaths(addedIndexPaths)
            let assetsToStopCaching = self.assetsAtIndexPaths(removedIndexPaths)

            self.imageManager?.startCachingImages(for: assetsToStartCaching,
                                                  targetSize: cellSize,
                                                  contentMode: .aspectFill,
                                                  options: nil)
            self.imageManager?.stopCachingImages(for: assetsToStopCaching,
                                                 targetSize: cellSize,
                                                 contentMode: .aspectFill,
                                                 options: nil)

            self.previousPreheatRect = preheatRect
        }
    }

    func computeDifferenceBetweenRect(_ oldRect: CGRect, andRect newRect: CGRect, removedHandler: (CGRect)->Void, addedHandler: (CGRect)->Void) {
        if newRect.intersects(oldRect) {
            let oldMaxY = oldRect.maxY
            let oldMinY = oldRect.minY
            let newMaxY = newRect.maxY
            let newMinY = newRect.minY
            if newMaxY > oldMaxY {
                let rectToAdd = CGRect(x: newRect.origin.x, y: oldMaxY, width: newRect.size.width, height: (newMaxY - oldMaxY))
                addedHandler(rectToAdd)
            }
            if oldMinY > newMinY {
                let rectToAdd = CGRect(x: newRect.origin.x, y: newMinY, width: newRect.size.width, height: (oldMinY - newMinY))
                addedHandler(rectToAdd)
            }
            if newMaxY < oldMaxY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: newMaxY, width: newRect.size.width, height: (oldMaxY - newMaxY))
                removedHandler(rectToRemove)
            }
            if oldMinY < newMinY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: oldMinY, width: newRect.size.width, height: (newMinY - oldMinY))
                removedHandler(rectToRemove)
            }
        } else {
            addedHandler(newRect)
            removedHandler(oldRect)
        }
    }

    func assetsAtIndexPaths(_ indexPaths: [IndexPath]) -> [PHAsset] {
        if indexPaths.count == 0 { return [] }

        var assets: [PHAsset] = []
        assets.reserveCapacity(indexPaths.count)
        for indexPath in indexPaths {
            let asset = self.images[indexPath.item] 
            assets.append(asset)
        }
        return assets
    }
}




