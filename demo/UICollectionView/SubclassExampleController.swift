
import UIKit

class SubclassExampleController: SCCollectionViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We want something fashion as our back button :)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "button_back"), style: .plain, target: self, action: #selector(SubclassExampleController.back(_:)))
    }
    
    func back(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func configureHeader(_ header: UICollectionReusableView) {
        // Since the header is recycled, I check for the existence of the imageview.
        var imageView: UIImageView? = header.viewWithTag(0) as? UIImageView
        if imageView != nil {
            
        } else {
            imageView = UIImageView(frame: header.bounds)
            imageView!.image = UIImage(named: "11-November")
            header.addSubview(imageView!)
        }
    }
    
    override func configureCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        // Simple cell with just a background color.
        cell.backgroundColor = UIColor.lightGray
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Let's say we want 10 cells for the demo.
        return 10
    }
}
