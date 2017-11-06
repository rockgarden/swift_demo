
import UIKit

class AddCellSubviewsbyXibVC: UITableViewController {

    var addInNib = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName:"MyCell", bundle:nil), forCellReuseIdentifier: "Cell") // Don't register anything! But the cell id must match the storyboard
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        // self.tableView.rowHeight = 58 // *
        let a = UIBarButtonItem(title: NSLocalizedString("addInNib", comment: ""), style: .plain, target: self, action: #selector(action))
        navigationItem.rightBarButtonItem = a
    }

    @objc func action() {
        addInNib = !addInNib
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if addInNib {
            let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! MyCell

            let lab = cell.theLabel! // * NB new IUO rules
            lab.text = "Add subviews by @IBOutlet"

            let iv = cell.theImageView! // * NB new IUO rules

            iv.image = shrinkImage()
            iv.contentMode = .center

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)

            // can refer to subviews by their tags
            // subview positioning configured by constraints in the nib!

            let lab = cell.viewWithTag(2) as! UILabel
            lab.text = "Add subviews by their tags"

            let iv = cell.viewWithTag(1) as! UIImageView

            iv.image = shrinkImage()
            iv.contentMode = .center
            return cell
        }
    }

}
