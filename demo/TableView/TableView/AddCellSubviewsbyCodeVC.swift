
import UIKit

class AddCellSubviewsbyCodeVC : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    /*
     As promised, the cell will never be nil and doesn't need to be an Optional.
     But we must find another test to decide whether initial configuration is needed
     (i.e. is this a blank empty new cell or is it reused, so that it was configured in a previous call to cellForRow).
     */

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        if cell.viewWithTag(1) == nil { // no subviews! add them
            let iv = UIImageView()
            iv.tag = 1
            cell.contentView.addSubview(iv)

            let lab = UILabel()
            lab.tag = 2
            cell.contentView.addSubview(lab)

            // since we are now adding the views ourselves,
            // we can use autolayout to lay them out

            let d = ["iv":iv, "lab":lab]
            iv.translatesAutoresizingMaskIntoConstraints = false
            lab.translatesAutoresizingMaskIntoConstraints = false
            var con = [NSLayoutConstraint]()
            // image view is vertically centered
            con.append(
                iv.centerYAnchor.constraint(equalTo:cell.contentView.centerYAnchor))
            // it's a square
            con.append(
                iv.widthAnchor.constraint(equalTo:iv.heightAnchor))
            // label has height pinned to superview
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[lab]|",
                                               metrics:nil, views:d))
            // horizontal margins
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-15-[lab]-15-[iv]-15-|",
                                               metrics:nil, views:d))
            NSLayoutConstraint.activate(con)


            lab.font = UIFont(name:"Helvetica-Bold", size:16)
            lab.lineBreakMode = .byWordWrapping
            lab.numberOfLines = 2

        }
        // can refer to subviews by their tags

        let lab = cell.viewWithTag(2) as! UILabel
        lab.text = "Add subviews by code"

        let iv = cell.viewWithTag(1) as! UIImageView

        iv.image = shrinkImage()
        iv.contentMode = .center
        
        return cell
    }
}

