
import UIKit


class Popover1VC : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(320,150)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:"Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        switch section {
        case 0:
            result = 2
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
        default:break
        }
    }
}


