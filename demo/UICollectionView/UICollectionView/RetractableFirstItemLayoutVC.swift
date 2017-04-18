
import UIKit

internal final class RetractableFirstItemLayoutVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    // MARK: - Private Properties
    // FlowLayout
    lazy fileprivate var flowLayout: RetractableFirstItemLayout = {
        let fl = RetractableFirstItemLayout()
        fl.firstItemRetractableAreaInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        return fl
    }()

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell.identifier")
        cv.register(TextCollectionViewCell.self, forCellWithReuseIdentifier: "TextCollectionViewCell.identifier")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.scrollsToTop = false
        cv.backgroundColor = UIColor.lightGray
        return cv
    }()

    fileprivate let colors = [
        "Emma":     UIColor(red: 81     / 255.0,    green: 81      / 255.0,     blue: 79       / 255.0,     alpha: 1.0),
        "Oliver":   UIColor(red: 242    / 255.0,    green: 94      / 255.0,     blue: 92       / 255.0,     alpha: 1.0),
        "Jack":     UIColor(red: 242    / 255.0,    green: 167     / 255.0,     blue: 92       / 255.0,     alpha: 1.0),
        "Olivia":   UIColor(red: 229    / 255.0,    green: 201     / 255.0,     blue: 91       / 255.0,     alpha: 1.0),
        "Harry":    UIColor(red: 35     / 255.0,    green: 123     / 255.0,     blue: 160      / 255.0,     alpha: 1.0),
        "Sophia":   UIColor(red: 112    / 255.0,    green: 193     / 255.0,     blue: 178      / 255.0,     alpha: 1.0)
    ]

    fileprivate var filteredNames: [String]!

    fileprivate let names = ["Emma", "Oliver", "Jack", "Olivia", "Harry", "Sophia"]

    fileprivate var readyForPresentation = false

    // MARK: - Object Lifecycle

    internal override func viewDidLoad() {

        super.viewDidLoad()

        self.filteredNames = self.names

        view.addSubview(collectionView)
        let views = ["cv":collectionView] as [String : Any]
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(0)-[cv]-(0)-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(64)-[cv]-(0)-|", options: [], metrics: nil, views: views),
            ].joined().map { $0 })
    }

    // MARK: - Layout

    internal override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()

        guard self.readyForPresentation == false else {
            return
        }

        self.readyForPresentation = true

        let searchItemIndexPath = IndexPath(item: 0, section: 0)
        self.collectionView.contentOffset = CGPoint(x: 0.0, y: self.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAt: searchItemIndexPath).height)
    }

    // MARK: - UICollectionViewDataSource

    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {

        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell.identifier", for: indexPath) as! SearchCollectionViewCell

            cell.searchBar.delegate = self
            cell.searchBar.searchBarStyle = .minimal
            cell.searchBar.placeholder = "Search - \(self.names.count) names"

            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCollectionViewCell.identifier", for: indexPath) as! TextCollectionViewCell

            let name = self.filteredNames[indexPath.item]

            cell.colorView.layer.cornerRadius = 10.0
            cell.colorView.layer.masksToBounds = true
            cell.colorView.backgroundColor = self.colors[name]

            cell.label.textColor = UIColor.white
            cell.label.textAlignment = .center
            cell.label.text = name

            return cell

        default:
            assert(false)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch section {

        case 0:
            return 1

        case 1:
            return self.filteredNames.count

        default:
            assert(false)
        }
    }

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 2
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        switch section {

        case 0:
            return UIEdgeInsets.zero

        case 1:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

        default:
            assert(false)
        }
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 10.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 10.0
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch indexPath.section {

        case 0:
            let itemWidth = collectionView.frame.width
            let itemHeight: CGFloat = 44.0

            return CGSize(width: itemWidth, height: itemHeight)

        case 1:
            let numberOfItemsInLine: CGFloat = 3

            let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)

            let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine
            let itemHeight = itemWidth

            return CGSize(width: itemWidth, height: itemHeight)

        default:
            assert(false)
        }
    }

    // MARK: - UIScrollViewDelegate

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        guard scrollView === self.collectionView else {

            return
        }

        let indexPath = IndexPath(item: 0, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else {

            return
        }

        guard cell.searchBar.isFirstResponder else {

            return
        }

        cell.searchBar.resignFirstResponder()
    }

    // MARK: - UISearchBarDelegate

    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let oldFilteredNames = self.filteredNames!

        if searchText.isEmpty {

            self.filteredNames = self.names
        }
        else {

            self.filteredNames = self.names.filter({ (name) -> Bool in

                return name.hasPrefix(searchText)
            })
        }

        self.collectionView.performBatchUpdates({

            for (oldIndex, oldName) in oldFilteredNames.enumerated() {

                if self.filteredNames.contains(oldName) == false {

                    let indexPath = IndexPath(item: oldIndex, section: 1)
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }

            for (index, name) in self.filteredNames.enumerated() {

                if oldFilteredNames.contains(name) == false {

                    let indexPath = IndexPath(item: index, section: 1)
                    self.collectionView.insertItems(at: [indexPath])
                }
            }

        }, completion: nil)
    }
}


internal final class SearchCollectionViewCell: UICollectionViewCell {

    // MARK: - Internal Properties

    internal var searchBar: UISearchBar!

    // MARK: - Object Lifecycle

    internal override init(frame: CGRect) {

        super.init(frame: frame)

        self.searchBar = UISearchBar()

        self.contentView.addSubview(self.searchBar)
    }

    internal required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    internal override func layoutSubviews() {

        super.layoutSubviews()

        self.searchBar.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
    }

    internal override class var requiresConstraintBasedLayout: Bool {

        return false
    }
}


internal final class TextCollectionViewCell: UICollectionViewCell {

    // MARK: - Internal Properties

    internal var colorView: UIView!

    internal var label: UILabel!

    // MARK: - Object Lifecycle

    internal override init(frame: CGRect) {

        super.init(frame: frame)

        self.colorView = UIView()
        self.label = UILabel()

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
