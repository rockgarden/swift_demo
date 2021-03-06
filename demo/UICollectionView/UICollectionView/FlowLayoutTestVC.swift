
import UIKit

class FlowLayoutTestVC: UICollectionViewController {
    var cellCount = 50

    open lazy var cellHeight:[CGFloat] = { //changed private to public
        var arr:[CGFloat] = []
        for _ in 0..<self.cellCount {
            arr.append(CGFloat(arc4random() % 150 + 40))
        }
        return arr
    }()

    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder:aDecoder)
    //        self.useLayoutToLayoutNavigationTransitions = true
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let flow = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.headerReferenceSize = CGSize(width: 50, height: 50)
            flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        }

        collectionView?.register(FlowLayoutTestCell.self, forCellWithReuseIdentifier: "FlowLayoutTestCellID")
        collectionView?.backgroundColor = UIColor.red //deleted ()

        // 瀑布流
        //setWaterFallLayout()
        // 圆形
        //setCircleLayout()
        // 线性
        setLineLayout()

        self.collectionView!.reloadData()
    }

    func setLineLayout() {
        let layout = LineLayout()
        layout.itemSize = CGSize(width: 100.0, height: 100.0)
        collectionView!.collectionViewLayout = layout
    }


    func setCircleLayout() {
        let layout = CircleLayout()
        collectionView?.collectionViewLayout = layout
    }

    func setWaterFallLayout() {
        let layout = WaterFallLayout()
        layout.delegate = self
        layout.numberOfColums = 4
        collectionView?.collectionViewLayout = layout
    }

}


extension FlowLayoutTestVC: WaterFallLayoutDelegate {
    func heightForItemAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}


extension FlowLayoutTestVC {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlowLayoutTestCellID", for: indexPath) as! FlowLayoutTestCell
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {//偶数
            cellCount -= 1
            cellHeight.remove(at: indexPath.row)
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        } else {
            cellCount += 1
            cellHeight.append(CGFloat(arc4random() % 150 + 40))

            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [indexPath])
            }, completion: nil)
        }
    }

}


internal final class FlowLayoutTestCell: UICollectionViewCell {

    // MARK: - Internal Properties
    internal var colorView: UIView!
    internal var label: UILabel!

    // MARK: - Object Lifecycle
    internal override init(frame: CGRect) {
        super.init(frame: frame)

        self.colorView = UIView()
        colorView.backgroundColor = .lightGray
        self.label = UILabel()
        label.backgroundColor = .white

        self.contentView.addSubview(self.colorView)
        self.contentView.addSubview(self.label)
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    internal override func layoutSubviews() {
        super.layoutSubviews()

        self.colorView.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
        self.label.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
    }
    
    internal override class var requiresConstraintBasedLayout: Bool {
        return false
    }
}

