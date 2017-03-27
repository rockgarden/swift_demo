//
//  HeaderDemoVC.swift
//


import UIKit

private let HDreuseIdentifier = "HDCell"

class HeaderDemoVC: UICollectionViewController {
    
    // MARK: properties
    fileprivate let dataSource = DataSource()
    
    // MARK: overide methods
    override var prefersStatusBarHidden : Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfGroups()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numbeOfRowsInEachGroup(section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SwiftCollectionViewCell
        // Configure the cell
        let languages = dataSource.fruitsInGroup(indexPath.section)
        let language = languages[indexPath.row]
        if let icon = language.icon,
            let name = language.name,
            let description = language.description {
            cell.imageView.image = UIImage(named: icon)
            cell.name.text = name
            cell.desc.text = description
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                withReuseIdentifier: "HeaderView",
                                                                for: indexPath) as! LangageHeaderViewCell
            headerView.title.text = dataSource.gettGroupLabelAtIndex(indexPath.section)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
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
    
}

class Language {
    var icon: String?
    var group:String?
    var name:String?
    var description: String?
    
    init(icon: String, group: String, name: String, description: String ) {
        self.icon = icon
        self.group = group
        self.name = name
        self.description = description
    }
}

class DataSource {
    
    init() {
        populateData()
    }
    
    var languages:[Language] = []
    var groups:[String] = []
    
    func numbeOfRowsInEachGroup(_ index: Int) -> Int {
        return fruitsInGroup(index).count
    }
    
    func numberOfGroups() -> Int {
        return groups.count
    }
    
    func gettGroupLabelAtIndex(_ index: Int) -> String {
        return groups[index]
    }
    
    // MARK:- Populate Data from plist
    func populateData() {
        if let path = Bundle.main.path(forResource: "languages", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let icon = dict["icon"] as! String
                        let name = dict["name"] as! String
                        let group = dict["group"] as! String
                        let description = dict["description"] as! String
                        
                        let fruit = Language(icon: icon, group: group, name: name, description: description)
                        if !groups.contains(group) {
                            groups.append(group)
                        }
                        languages.append(fruit)
                    }
                }
            }
        }
    }
    
    // MARK:- FruitsForEachGroup
    func fruitsInGroup(_ index: Int) -> [Language] {
        let item = groups[index]
        let filteredFruits = languages.filter { (language: Language) -> Bool in
            return language.group == item
        }
        return filteredFruits
    }
}


class SwiftCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
}


class LangageHeaderViewCell: UICollectionReusableView {
    @IBOutlet weak var title: UILabel!
}

