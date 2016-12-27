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
        let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!)
        let states = s.components(separatedBy:"\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append(c.uppercased())
                // and in that case also add new subarray to our array of subarrays
                self.cellData.append([String]())
            }
            self.cellData[self.cellData.count-1].append(aState)
        }
        self.navigationItem.title = "States"

        self.collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        // if you don't do something about header size...
        // ...you won't see any headers
        let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.headerReferenceSize = CGSize(30,30)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellData[section].count
    }

    // minimal formatting; this is just to prove we can show the data at all

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
        lab.text = (self.cellData)[indexPath.section][indexPath.row] // "item" synonym for "row"
        lab.sizeToFit()
        return cell

    }
}

// but the above is not sufficient to see the entire name of a state
// the state names are stepping on each other; let's fix that
// adjust the size of each cell, as a UICollectionViewDelegateFlowLayout

extension FlowLayoutVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // note horrible duplication of code here
        let lab = UILabel(frame:CGRect(0,0,30,30))
        lab.text = (self.cellData)[indexPath.section][indexPath.row]
        lab.sizeToFit()
        return lab.bounds.size
    }
}

// that duplication is exactly what iOS 8 is supposed to fix with _automatic_ variable cell size
// but I can't get that to work (see next example for my workaround using constraints)


