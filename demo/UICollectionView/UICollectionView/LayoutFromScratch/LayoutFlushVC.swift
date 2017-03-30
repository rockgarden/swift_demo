
import UIKit

class LayoutFlushVC : UICollectionViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.useLayoutToLayoutNavigationTransitions = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "States 2"
        let b = UIBarButtonItem(title:"Flush", style:.plain, target:self, action:#selector(doFlush))
        self.navigationItem.rightBarButtonItem = b
        if let flow = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.headerReferenceSize = CGSize(width: 50,height: 50)
            flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        }
        self.collectionView!.reloadData()
    }
    
    func doFlush (_ sender:AnyObject) {
        if let layout = self.collectionView!.collectionViewLayout as? FlushFlowLayout {
            layout.flush()
        }
    }
    
    // extremely weird transfer of responsibilities
    // I filed a bug on this but Apple insists this is how they want it...
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(String(describing: self.collectionView!.dataSource)) \(String(describing: self.collectionView!.delegate))")
        return
    }
    
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
        print("\(String(describing: self.collectionView!.dataSource)) \(String(describing: self.collectionView!.delegate))")
        delay(2) {
            print("\(String(describing: self.collectionView!.dataSource)) \(String(describing: self.collectionView!.delegate))")
        }
        return
    }

}


// MARK: UICollectionViewDelegateFlowLayout
extension LayoutFlushVC : UICollectionViewDelegateFlowLayout {

    // but I don't want to be the delegate, because I need the data for that, and I don't have it!
    // (this is what I couldn't get Apple to understand; how can the data source and delegate be different?)
    // so I forward delegation back to the other view controller
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("forwarding to the other view controller")
        //let cv = self.navigationController!.viewControllers[0] as! ViewController
        let cv = self.navigationController!.viewControllers[1] as! LayoutNormalVC //加入了TableVC, 所以取的是1
        let result = cv.collectionView(collectionView, layout:collectionViewLayout,
                                       sizeForItemAt:indexPath)
        return result
    }
    
}
