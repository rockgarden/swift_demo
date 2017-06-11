import UIKit

// FIXME: Unable to simultaneously satisfy constraints.
class CalculateVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    lazy fileprivate var flowLayout: UICollectionViewFlowLayout = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 10
        fl.scrollDirection = .vertical
        fl.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        fl.sectionFootersPinToVisibleBounds = false
        return fl
    }()

    lazy fileprivate var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        v.backgroundColor = .lightGray
        v.showsVerticalScrollIndicator = true
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        v.dataSource = self
        v.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "LabelCell")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let columnNum: CGFloat = 3 //use number of columns instead of a static maximum cell width
    var cellWidth: CGFloat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white

        view.addSubview(collectionView)
        let views = ["msv": collectionView]

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(64)-[msv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map{$0})
    }
    
    override func viewDidLayoutSubviews()
    {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columnNum - 1)
            let totalCellAvailableWidth = collectionView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - spaceBetweenCells
            cellWidth = floor(totalCellAvailableWidth / columnNum);
        }
    }

    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        /// recalculate the collection view layout when the view layout changes
        collectionView.collectionViewLayout.invalidateLayout()
    }

    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! LabelCell
        cell.configureWithIndexPath(indexPath)
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    /// 相当于 UICollectionViewFlowLayout().estimatedItemSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if let cell = LabelCell.fromNib() {
            let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
            cell.configureWithIndexPath(indexPath)
            cell.label.preferredMaxLayoutWidth = cellWidth - cellMargins
            cell.labelWidthLayoutConstraint.constant = cellWidth - cellMargins //adjust the width to be correct for the number of columns
            return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize) //apply auto layout and retrieve the size of the cell
        }
        return CGSize.zero
    }
}

