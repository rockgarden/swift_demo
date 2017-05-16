
import UIKit

class TransitionImageCollectionVC: UICollectionViewController {

    private let screenW = UIScreen.main.bounds.size.width
    private let screenH = UIScreen.main.bounds.size.width
    
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenW/4 - 4, height: screenH/4 - 4)
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
        
        collectionView?.backgroundColor = .white
        collectionView?.collectionViewLayout = layout
        navigationController?.delegate = self
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
        let vc = ImageDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension TransitionImageCollectionVC: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if operation == .push {
            guard let indexPath = (collectionView?.indexPathsForSelectedItems?[0]) else {return nil}
            let cell = collectionView?.cellForItem(at: indexPath) as! CollectionViewCell
            let iv = cell.imageView
            iv?.isHidden = true
            let imageName = images[indexPath.row]
            
            var cellRect = cell.frame
            cellRect.origin.y += (collectionView?.contentInset.top)!
            return TransitionPresentationAnimator(frame: cellRect, imageName: imageName)
        }
        
        if operation == .pop {
            if toVC is TransitionImageCollectionVC {
                return TransitionDismissalAnimator()
            }
        }

        return nil
    }
    
    func showSelectedImageView(_ frame: CGRect){
        let indexPath = (collectionView?.indexPathForItem(at: frame.origin))!
        let cell = collectionView?.cellForItem(at: indexPath) as! CollectionViewCell
        let imageView = cell.imageView
        imageView?.isHidden = false
    }
}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}


class ImageDetailVC: UIViewController {
    
    fileprivate var imageView: UIImageView?
    
    func setImageView(_ imageView: UIImageView?) {
        if let iv = imageView {
            self.imageView = iv
            view.addSubview(iv)
        }
    }
    
    func getImageView() -> UIImageView? {
        return imageView
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
