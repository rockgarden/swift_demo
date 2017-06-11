import UIKit

// FIXME: [LayoutConstraints] Unable to simultaneously satisfy constraints.
class LabelCell: UICollectionViewCell
{
    @IBOutlet var label: UILabel!
    @IBOutlet var labelWidthLayoutConstraint: NSLayoutConstraint! //used for setting the width via constraint

    /**
        Allows you to generate a cell without dequeueing one from a table view.
        - Returns: The cell loaded from its nib file.
    */
    class func fromNib() -> LabelCell?
    {
        var cell: LabelCell?
        let nibViews = Bundle.main.loadNibNamed("LabelCell", owner: nil, options: nil)
        for nibView in nibViews! {
            if let cellView = nibView as? LabelCell {
                cell = cellView
            }
        }
        return cell
    }
    
    /**
        Sets the cell styles and content.
    */
    func configureWithIndexPath(_ indexPath: IndexPath)
    {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        label.text = labelTextWithNum(indexPath.item + 1)
        label.preferredMaxLayoutWidth = 50
    }
    
    /**
        Generate a simple label text.
        - Returns: The text for the label.
    */
    fileprivate func labelTextWithNum(_ num: Int) -> String
    {
        var text = "1"
        if num > 1 {
            for t in 2...num {
                text = text + " \(t)"
            }
        }
        return text
    }
}
