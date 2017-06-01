
import UIKit

class Popover1View1 : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // as far as I can tell, this has to be determined experimentally
        self.preferredContentSize = CGSize(320,220)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:"Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        switch section {
        case 0:
            result = 2
        case 1:
            result = 1
        default:break
        }
        return result
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 
        
        let section = indexPath.section
        let row = indexPath.row
        let choice = UserDefaults.standard.integer(forKey:"choice")
        switch section {
        case 0:
            switch row {
            case 0:
                cell.textLabel!.text = "First"
            case 1:
                cell.textLabel!.text = "Second"
            default:break
            }
            cell.accessoryType = (choice == row ?
                .checkmark :
                .none)
        case 1:
            cell.textLabel!.text = "Change size"
            cell.accessoryType = .disclosureIndicator
        default:break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            UserDefaults.standard.set(row, forKey:"choice")
            tableView.reloadData()
        case 1:
            let nextView = Popover1View2()
            // iOS 8 method, I do like not having to know we are in a navigation controller
            self.show(nextView, sender:self)
        default:break
        }
    }
}

class Popover1View2 : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.preferredContentSize = CGSize(400,400)
    }
}
