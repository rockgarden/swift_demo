
import UIKit

class CALayerVC: UIViewController {

    @IBOutlet fileprivate var box: UIView!
    @IBOutlet fileprivate var replicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBox()
    }
    
    func setupBox() {
        // Creating rounder corners
        box.layer.cornerRadius = 10
        
        // Adding shadow effects
        box.layer.shadowOffset = CGSize(width: 5, height: 5) //偏移量 右侧 5 个点以及下方 5 个点
        box.layer.shadowOpacity = 0.7
        box.layer.shadowRadius = 5
        box.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
        // Applying borders
        box.layer.borderColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        box.layer.borderWidth = 3
        
        // Display images
        box.layer.contents = UIImage(named: "tree.jpg")?.cgImage //使用文件名 tree.jpg 创建了一个 UIImage 对象，然后把它传给了图层的 contents 属性。
        box.layer.contentsGravity = kCAGravityResize //设置图层的内容重心来调整大小，这意味着图层中的所有内容将被调整大小以便完美地适应图层的尺寸。
        box.layer.masksToBounds = true //以便图层中任何延伸到边界外的子图层都会在边界处被剪裁。
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let lay = ReplicatorLayer()
        replicator.layer.addSublayer(lay)
        lay.position = CGPoint(replicator.layer.bounds.midX, replicator.layer.bounds.midY)
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

}


