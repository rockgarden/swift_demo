//
//  FlowLayoutVC.swift
//  UICollectionView
//

import UIKit

class FlowLayoutVC : UICollectionViewController {

    var sectionNames = [String]()
    var cellData = [[String]]()

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        prepareData(sectionNames: &sectionNames, cellData: &cellData)
        sectionNames.append("familyNames")
        cellData.append(UIFont.familyNames)
        
        self.navigationItem.title = "States"

        self.collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")

        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.headerReferenceSize = CGSize(30,30)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellData[section].count
    }

    // headers
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:"Header", for: indexPath)
            if v.subviews.count == 0 {
                v.addSubview(UILabel(frame:CGRect(0,0,30,30)))
            }
            let lab = v.subviews[0] as! UILabel
            lab.text = (self.sectionNames)[indexPath.section]
            lab.textAlignment = .center
        }
        return v
    }

    // cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"Cell", for: indexPath)
        if cell.contentView.subviews.count == 0 {
            cell.contentView.addSubview(UILabel(frame:CGRect(0,0,30,30)))
        }
        let lab = cell.contentView.subviews[0] as! UILabel
        lab.text = (self.cellData)[indexPath.section][indexPath.row] //"item" == "row"
        lab.sizeToFit()
        return cell
    }
}


// MARK: -  UICollectionViewDelegateFlowLayout
/// adjust the size of each cell
extension FlowLayoutVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lab = UILabel(frame:CGRect(0,0,30,30))
        lab.text = (self.cellData)[indexPath.section][indexPath.row]
        lab.sizeToFit()
        return lab.bounds.size
    }
}

/// that duplication is exactly what iOS 8 is supposed to fix with _automatic_ variable cell size but I can't get that to work (see next example for my workaround using constraints)


