
import UIKit

class InitCellbyCodeVC : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CodeCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.tableView.rowHeight = 58
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! CodeCell
        if cell.textLabel!.numberOfLines != 2 { // never previously configured
            cell.textLabel!.font = UIFont(name:"Helvetica-Bold", size:16)
            cell.textLabel!.lineBreakMode = .byWordWrapping
            cell.textLabel!.numberOfLines = 2
            // next line fails, I regard this as a bug
            // cell.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        }

        cell.textLabel!.text = "Init cell by code."

        cell.imageView!.image = shrinkImage()
        cell.imageView!.contentMode = .center

        return cell
    }
    
}

class CodeCell : UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:.default, reuseIdentifier: reuseIdentifier)
        // change .default to another built-in style if desired
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cvb = self.contentView.bounds
        let imf = self.imageView!.frame
        self.imageView!.frame.origin.x = cvb.size.width - imf.size.width - 15
        self.textLabel!.frame.origin.x = 15
    }
}
