

import UIKit

class MasterViewController: UITableViewController {
    
    var objects = [Date]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject))
        navigationItem.rightBarButtonItems = [addButton,editButtonItem]

        // TODO: show what ??
        NotificationCenter.default.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: nil) { _ in
            print(UIFont.preferredFont(forTextStyle: .headline))
            print(UIFont.buttonFontSize)
            print(UIFont.labelFontSize)
        }
    }
    
    @objc func insertNewObject(_ sender: AnyObject) {
        objects.insert(Date(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let object = objects[indexPath.row] 
            (segue.destination as! DetailViewController).detailItem = object as AnyObject
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    // TODO: 测试效果
    /**
     Put a symbolic breakpoint on -[UILabel setFont:]
     You will see that when dynamic type is triggered,
     the table view's layoutSubviews is called;
     this causes the cells to be recreated,
     and so the fonts for the labels are freshly set.
     The table is _always_ listening for the dynamic type notification;
     it doesn't have special knowledge that dynamic type is actually being used.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel!.text = object.description
        if #available(iOS 10.0, *) {
            cell.textLabel!.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        return cell
    }
    // good code
    //    if cell.contentView.viewWithTag(1) == nil {
    //    let lab = UILabel()
    //    print(lab.lineBreakMode.rawValue)
    //    let color = indexPath.row == 0 ? UIColor.blackColor() : UIColor.blueColor()
    //    let s = NSMutableAttributedString(string: "This is\n a test", attributes: [
    //    NSForegroundColorAttributeName : color
    //    ])
    //    lab.attributedText = s
    //    lab.sizeToFit()
    //    lab.tag = 1
    //    lab.highlightedTextColor = UIColor.redColor()
    //    cell.contentView.addSubview(lab)
    //    }

    /*
     let viewTag = 101
     var lab: UILabel!
     if let v = v.viewWithTag(viewTag) as? UILabel{
     lab = v
     }else{
     lab = UILabel(frame: v.bounds)
     lab.tag = 101
     v.addSubview(lab)
     }
     */

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

