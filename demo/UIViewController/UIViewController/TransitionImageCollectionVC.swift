
import UIKit

class TransitionImageCollectionVC: UICollectionViewController {
    
    var layout : UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4 - 4, height: UIScreen.main.bounds.size.width/4 - 4)
        layout.minimumInteritemSpacing = 4.0
        layout.minimumLineSpacing = 4.0
        return layout
    }
    
    var images: [String] = [
        "castle",
        "cow",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.collectionViewLayout = self.layout
        self.navigationController?.delegate = self
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ImageDetailVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TransitionImageCollectionVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            let selectedIndexPaths = self.collectionView?.indexPathsForSelectedItems
            let indexPath: IndexPath = selectedIndexPaths![0]
            let collectionViewCell = self.collectionView?.cellForItem(at: indexPath)
            let imageView = (collectionViewCell as! CollectionViewCell).imageView
            imageView?.isHidden = true
            let imageName = images[indexPath.row]
            
            var cellRect = collectionViewCell!.frame
            cellRect.origin.y += (self.collectionView?.contentInset.top)!
            return TransitionPresentationAnimator(frame: cellRect, imageName: imageName)
        }
        
        if operation == .pop {
            return TransitionDismissalAnimator()
        }
        
        return nil
    }
    
    func showSelectedImageView(_ frame: CGRect){
        let indexPath: IndexPath = (self.collectionView?.indexPathForItem(at: frame.origin))!
        let collectionViewCell = self.collectionView?.cellForItem(at: indexPath)
        let imageView = (collectionViewCell as! CollectionViewCell).imageView
        imageView?.isHidden = false
    }
}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

class ImageDetailVC: UIViewController {
    
    fileprivate var imageView: UIImageView?
    
    func setImageView(_ imageView: UIImageView?) {
        if let imgView = imageView {
            self.imageView = imgView
            self.view.addSubview(imgView)
        }
    }
    
    func getImageView() -> UIImageView? {
        return self.imageView
    }
    
    // set original image frame
    fileprivate var originalFrame: CGRect?
    func setOriginalImageFrame(_ frame: CGRect) {
        self.originalFrame = frame
    }
    
    func getOriginalImageFrame() -> CGRect? {
        return self.originalFrame
    }
}
