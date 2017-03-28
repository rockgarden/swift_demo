//
//  SectionDemoVC.swift
//  UICollectionView
//

import UIKit

/// EstimatedItemSize & Section Demo
class SectionDemoVC: UICollectionViewController {

    fileprivate var papersDataSource = PapersDataSource()
    fileprivate let reuseIdentifier = "PaperCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = collectionView!.frame.width
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        /// 启用自适应contentView的内容
        layout.estimatedItemSize = CGSize(width: width, height: width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //  override func prepareForSegue(segue: UIStoryboardSegue, sender:
    //    AnyObject?) {
    //      if segue.identifier == "MasterToDetail" {
    //        if let indexPath = collectionView!.indexPathsForSelectedItems()!.first {
    //            if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
    //                let detailViewController = segue.destinationViewController as! DetailViewController
    //                detailViewController.paper = paper
    //            }
    //        }
    //      }
    //  }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MasterToDetail" {
            let detailViewController = segue.destination as! SectionDemoDetailVC
            detailViewController.paper = sender as? Paper
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return papersDataSource.numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(papersDataSource.count)")
        return papersDataSource.numberOfPapersInSection(section)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView

        if let title = papersDataSource.titleForSectionAtIndexPath(indexPath) {
            sectionHeaderView.title = title
        }
        return sectionHeaderView
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaperCell", for: indexPath) as! PaperCell

        // Configure the cell
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            cell.paper = paper
        }
        /// 若从网络下载图片,则可在完成后调用
        collectionView.reloadItems(at: [indexPath])
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }

     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }

     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {

     }
     */

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            performSegue(withIdentifier: "MasterToDetail", sender: paper)
        }
    }
    
}


// MARK: Data Source
class PapersDataSource {

    fileprivate var papers: [Paper] = []
    fileprivate var immutablePapers: [Paper] = []
    fileprivate var sections: [String] = []

    var count: Int {
        return papers.count
    }

    var numberOfSections: Int {
        return sections.count
    }

    // MARK: Public

    init() {
        papers = loadPapersFromDisk()
        immutablePapers = papers
    }

    func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
        var indexes: [Int] = []
        for indexPath in indexPaths {
            indexes.append(absoluteIndexForIndexPath(indexPath))
        }
        var newPapers: [Paper] = []
        for (index, paper) in papers.enumerated() {
            if !indexes.contains(index) {
                newPapers.append(paper)
            }
        }
        papers = newPapers
    }

    func indexPathForNewRandomPaper() -> IndexPath {
        let index = Int(arc4random_uniform(UInt32(immutablePapers.count)))
        let paperToCopy = immutablePapers[index]
        let newPaper = Paper(copying: paperToCopy)
        papers.append(newPaper)
        papers.sort { $0.index < $1.index }
        return indexPathForPaper(newPaper)
    }

    func indexPathForPaper(_ paper: Paper) -> IndexPath {
        let section = sections.index(of: paper.section)!
        var item = 0
        for (index, currentPaper) in papersForSection(section).enumerated() {
            if currentPaper === paper {
                item = index
                break
            }
        }
        return IndexPath(item: item, section: section)
    }

    func movePaperAtIndexPath(_ indexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
        if indexPath == newIndexPath {
            return
        }
        let index = absoluteIndexForIndexPath(indexPath)
        let paper = papers[index]
        paper.section = sections[newIndexPath.section]
        let newIndex = absoluteIndexForIndexPath(newIndexPath)
        papers.remove(at: index)
        papers.insert(paper, at: newIndex)
    }

    func numberOfPapersInSection(_ index: Int) -> Int {
        let papers = papersForSection(index)
        return papers.count
    }

    func paperForItemAtIndexPath(_ indexPath: IndexPath) -> Paper? {
        if indexPath.section > 0 {
            let papers = papersForSection(indexPath.section)
            return papers[indexPath.item]
        } else {
            return papers[indexPath.item]
        }
    }

    func titleForSectionAtIndexPath(_ indexPath: IndexPath) -> String? {
        if indexPath.section < sections.count {
            return sections[indexPath.section]
        }
        return nil
    }

    // MARK: Private
    fileprivate func absoluteIndexForIndexPath(_ indexPath: IndexPath) -> Int {
        var index = 0
        for i in 0..<indexPath.section {
            index += numberOfPapersInSection(i)
        }
        index += indexPath.item
        return index
    }

    fileprivate func loadPapersFromDisk() -> [Paper] {
        sections.removeAll(keepingCapacity: false)
        if let path = Bundle.main.path(forResource: "Papers", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                var papers: [Paper] = []
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let caption = dict["caption"] as! String
                        let imageName = dict["imageName"] as! String
                        let section = dict["section"] as! String
                        let index = dict["index"] as! Int
                        let paper = Paper(caption: caption, imageName: imageName, section: section, index: index)
                        if !sections.contains(section) {
                            sections.append(section)
                        }
                        papers.append(paper)
                    }
                }
                return papers
            }
        }
        return []
    }
    
    fileprivate func papersForSection(_ index: Int) -> [Paper] {
        let section = sections[index]
        let papersInSection = papers.filter { (paper: Paper) -> Bool in
            return paper.section == section
        }
        return papersInSection
    }
    
}


// MARK: - Detail VC
class SectionDemoDetailVC: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!

    var paper: Paper?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let paper = paper {
            navigationItem.title = paper.caption
            imageView.image = UIImage(named: paper.imageName)
        }
    }
    
}


// MARK: - Model Paper
class Paper {

    var caption: String
    var imageName: String
    var section: String
    var index: Int

    init(caption: String, imageName:String, section: String, index: Int) {
        self.caption = caption
        self.imageName = imageName
        self.section = section
        self.index = index
    }

    convenience init(copying paper: Paper) {
        self.init(caption: paper.caption, imageName: paper.imageName, section: paper.section, index: paper.index)
    }
    
}


// MARK: - Cell View
class PaperCell: UICollectionViewCell {

    @IBOutlet weak var paperImageView: UIImageView! {
        didSet {
            paperImageView.layer.cornerRadius = 8
            paperImageView.layer.masksToBounds = true
            /// 自适应图片宽高比例
            paperImageView.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    @IBOutlet fileprivate weak var gradientView: GradientView!
    @IBOutlet fileprivate weak var captionLabel: UILabel!

    var paper: Paper? {
        didSet {
            if let paper = paper {
                if let i = UIImage(named: paper.imageName) {
                    paperImageView.image = i
                } else {
                    /// 若是 image = nil 则 调整 paperImageView constraints 从而让 contentView 适应内容, 但会导致 在cell view 复用时 布局异常; 所以最优的办法是加载一张图片, 以内容驱动!
                    debugPrint(captionLabel.constraints)
                    debugPrint(paperImageView.constraints)
                    //paperImageView.constraints[0].constant = captionLabel.constraints[0].constant
                    //paperImageView.constraints[1].constant = captionLabel.constraints[2].constant
                    let i = UIImage(color: .clear, size: CGSize(width:captionLabel.constraints[0].constant, height: captionLabel.constraints[1].constant))
                    paperImageView.image = i
                }
                captionLabel.text = paper.caption
            }
        }
    }


}


// MARK: - Header View
class SectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}


// MARK: - GradientView
class GradientView: UIView {

    lazy fileprivate var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor(white: 0.0, alpha: 0.75).cgColor]
        layer.locations = [NSNumber(value: 0.0 as Float), NSNumber(value: 1.0 as Float)]
        return layer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

fileprivate extension UIImage {

    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        //self(cgImage: (image?.cgImage!)!)
    }

    convenience init(color: UIColor, rect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}
