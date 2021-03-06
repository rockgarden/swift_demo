//
//  StickyHeaderDemoVC.swift
//


import UIKit

class StickyHeaderDemoVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellIdentifier: String = "StickyCell"
    let data: [CGFloat] = [100,200,300,300,200,100]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(UINib(nibName: "MyCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MyCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        debugPrint(collectionView.contentSize)
        return CGSize(width: UIScreen.main.bounds.width, height: data[indexPath.item])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        positionCells(scrollView)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        positionCells(scrollView)
    }
    
    func positionCells(_ scrollView: UIScrollView) {
        let cells = self.collectionView?.visibleCells
        let scrollOffset = scrollView.contentOffset.y
        
        for cell in cells as! [MyCell] {
            let cellOffset = cell.frame.origin.y
            let headerOffset = scrollOffset - cellOffset
            if headerOffset >= 0 {
                cell.headerTop?.constant = headerOffset
            } else {
                cell.headerTop?.constant = 0
            }
        }
    }
}

