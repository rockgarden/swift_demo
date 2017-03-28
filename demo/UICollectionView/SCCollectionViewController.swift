
import UIKit

open
class SCCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Set the cell margin (spacing between lines, columns, and left/right borders of the collectionview). Default to 5
    open var cellMargin: CGFloat = 5
    // Set the cell height. default to 120.
    open var cellHeight: CGFloat = 120
    // Set the base height for the header (height when not scaled up).
    open var headerBaseHeight: CGFloat = 170
    
    /**
    You must override this method to provide the number of cells to show below the header.
    */
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("You must override this dataSource method")
    }
    
    /**
    You must override this method to configure the header view as you like.
    
    :param: header The recycled UICollectionReusableView.
    */
    open func configureHeader(_ header: UICollectionReusableView) {
        fatalError("You must override this method to configure the header view as you like.")
    }
    
    /**
    You must override this method to configure the cells to your convenience.
    
    :param: cell        The recycled UICollectionViewCell.
    :param: indexPath   The corresponding indexPath.
    */
    open func configureCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        fatalError("You must override this method to configure the cells as you like.")
    }
    
    fileprivate let reuseIdentifier = "Cell"
    fileprivate let headerReuseIdentifier = "Header"
    fileprivate var growingHeader: UIView?
    fileprivate let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let headerMask = CALayer()
    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Configure UICollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = self.view.bounds
        collectionView.backgroundColor = UIColor.clear
        collectionView.clipsToBounds = false
        
        // Let the scrollview go under navigationBar.
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Hide the navigation bar at first
        if let unwrappedNavigationController = self.navigationController {
            unwrappedNavigationController.navigationBar.alpha = 0
        }
        
        headerMask.backgroundColor = UIColor(white: 1, alpha: 1).cgColor
        self.view.addSubview(collectionView)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let unwrappedNavigationController = self.navigationController {
            self.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
                unwrappedNavigationController.navigationBar.alpha = 0
                }, completion: nil)
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let unwrappedNavigationController = self.navigationController {
            self.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
                unwrappedNavigationController.navigationBar.alpha = 1
                }, completion: nil)
        }
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = self.view.bounds
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    final public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numColumns: CGFloat = 1
        let edgeInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let spacingLeft = edgeInset.left
        let spacingRight = edgeInset.right
        let width = (collectionView.bounds.size.width - spacingLeft - spacingRight - cellMargin*(numColumns-1)) / numColumns
        return CGSize(width: width, height: cellHeight)
    }
    
    final public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
    }
    
    final public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    final public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    final public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: headerBaseHeight)
    }
    
    // MARK: UICollectionViewDataSource
    
    final public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    final public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
        
        // Configure the cell
        cell.backgroundColor = UIColor.clear
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    final public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let supplementaryView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) 
            
            growingHeader = supplementaryView as UIView
            growingHeader!.clipsToBounds = false
            growingHeader!.backgroundColor = UIColor.clear
            
            configureHeader(supplementaryView)
            
            growingHeader!.layer.mask = headerMask
            adjustHeaderMaskWithScrollOffset(collectionView.contentOffset.y)
            
            return supplementaryView
        }
        return UICollectionReusableView()
    }
    
    final public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let unwrapperGrowingHeader = growingHeader {
            let scrollOffset = scrollView.contentOffset.y
            let scale = 1 + (min(0, scrollOffset * 0.011)) * (-1.0)
            var transform = CGAffineTransform(scaleX: scale, y: scale)
            if (scrollOffset <= 0) {
                transform = transform.translatedBy(x: 0, y: min(0, scrollOffset*0.1))
            } else {
                transform = transform.translatedBy(x: 0, y: min(scrollOffset*0.5, 60))
            }
            unwrapperGrowingHeader.transform = transform
            adjustHeaderMaskWithScrollOffset(scrollOffset)
            
            if let unwrappedNavigationController = self.navigationController {
                let barAlpha = max(0, min(1, (scrollOffset/80)))
                unwrappedNavigationController.navigationBar.alpha = barAlpha
            }
        }
    }
    
    fileprivate func adjustHeaderMaskWithScrollOffset(_ offset: CGFloat) {
        // Find bottom of header without growing effect
        let maskBottom = self.view.convert(CGPoint(x: 0, y: headerBaseHeight-offset), to: growingHeader)
        // We set appropriate frame to clip the header
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        headerMask.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: maskBottom.y)
        CATransaction.commit()
    }
}
