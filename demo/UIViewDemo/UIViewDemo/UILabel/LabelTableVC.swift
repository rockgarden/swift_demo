

import UIKit

class LabelTableVC: UITableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    /// the black label text turns red when the cell is selected, but the blue label text does not - highlightedTextColor does not work on it 当选择单元格时，黑色标签文本变为红色, 但蓝色标签文本不会 - highlightTextColor不起作用

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        
        if cell.contentView.viewWithTag(1) == nil {
            let lab = UILabel()
            print(lab.lineBreakMode.rawValue)

            lab.textColor = .blue

            /// the rule is that the attributed text color must _match_ the textColor, if not - highlightedTextColor does not work on!
            let color = indexPath.row == 0 ? UIColor.blue : UIColor.black
            let s = NSMutableAttributedString(string: "This is\n a test", attributes: [
                NSForegroundColorAttributeName : color
            ])
            lab.attributedText = s
            lab.sizeToFit()
            lab.tag = 1
            lab.highlightedTextColor = .red
            cell.contentView.addSubview(lab)
        }
        return cell
    }
}
