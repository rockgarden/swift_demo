

import UIKit

class SectionsVC : AppTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // not useful in this situation
        tableView.separatorEffect = UIBlurEffect(style: .dark)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return nil //no section
        return self.sectionNames[section]
    }

    // this is more "interesting"
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h = tableView.dequeueReusableHeaderFooterView(withIdentifier:"Header")!
        if h.viewWithTag(1) == nil {
            print("configuring a new header view") // only called about 8 times

            h.backgroundView = UIView()
            h.backgroundView?.backgroundColor = .black
            let lab = UILabel()
            lab.tag = 1
            lab.font = UIFont(name:"Georgia-Bold", size:22)
            lab.textColor = .green
            lab.backgroundColor = .clear
            h.contentView.addSubview(lab)
            let v = UIImageView()
            v.tag = 2
            v.backgroundColor = .black
            v.image = UIImage(named:"us_flag_small.gif")
            h.contentView.addSubview(v)
            lab.translatesAutoresizingMaskIntoConstraints = false
            v.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-5-[lab(25)]-10-[v(40)]",
                                               metrics:nil, views:["v":v, "lab":lab]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|",
                                               metrics:nil, views:["v":v]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[lab]|",
                                               metrics:nil, views:["lab":lab])
                ].flatMap{$0})

            // uncomment to see bug where button does not inherit superview's tint color
            let b = UIButton(type:.system)
            b.setTitle("Howdy", for:.normal)
            b.sizeToFit()
            print(b.tintColor)
            h.addSubview(b)
        }
        let lab = h.contentView.viewWithTag(1) as! UILabel
        lab.text = self.sectionNames[section]
        print(h.backgroundView?.backgroundColor as Any)
        return h

    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return 32
        return UITableViewAutomaticDimension //压缩
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print(view) //prove we are reusing header views
    }
}
