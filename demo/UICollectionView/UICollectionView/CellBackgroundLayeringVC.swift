//
//  CellBackgroundLayeringVC.swift
//  UICollectionView
//

import UIKit

class CellBackgroundLayeringVC : UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(150,50)

        let v = UIView()
        v.backgroundColor = .yellow
        /// makes the whole background yellow, covering the background color
        self.collectionView?.backgroundView = v
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    // window background is white
    // collection view background (from storyboard) is green

    /*
     the window background never appears
     the collection view background appears when you "bounce" the scroll beyond its limits
     */

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"Cell",
                                                      for: indexPath)
        if cell.backgroundView == nil {
            cell.backgroundColor = .red

            let v = UIImageView(frame:cell.bounds)
            v.contentMode = .scaleToFill
            v.image = UIImage(named:"linen")
            cell.backgroundView = v

            let v2 = UIView(frame:cell.bounds)
            v2.backgroundColor = UIColor(white:0.2, alpha:0.1)
            cell.selectedBackgroundView = v2

            let lab = UILabel()
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.tag = 1
            cell.contentView.addSubview(lab)
            NSLayoutConstraint.activate([
                lab.centerXAnchor.constraint(equalTo:cell.contentView.centerXAnchor),
                lab.centerYAnchor.constraint(equalTo:cell.contentView.centerYAnchor)
                ])
            lab.textColor = .black
            lab.highlightedTextColor = .white
            lab.backgroundColor = .clear
        }
        let lab = cell.viewWithTag(1) as! UILabel
        lab.text = "Howdy there \(indexPath.item)"
        return cell
    }
    
}
