
import UIKit

class RowActionsVC : AppTableVC {

    let which = 0 /// 0 for manual, 1 for built-in edit button

    override func viewDidLoad() {
        super.viewDidLoad()

        switch which {
        case 0:
            let b = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(doEdit))
            self.navigationItem.rightBarButtonItem = b
        case 1:
            self.navigationItem.rightBarButtonItem = self.editButtonItem
        default:break
        }
    }

    func doEdit(_ sender: Any?) {
        var which : UIBarButtonSystemItem
        if !self.tableView.isEditing {
            self.tableView.setEditing(true, animated:true)
            which = .done
        } else {
            self.tableView.setEditing(false, animated:true)
            which = .edit
        }
        let b = UIBarButtonItem(barButtonSystemItem: which, target: self, action: #selector(doEdit(_:)))
        self.navigationItem.rightBarButtonItem = b
    }


    // MARK: Edit handling ==========

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt ip: IndexPath) {
        self.sectionData[ip.section].remove(at:ip.row)
        switch editingStyle {
        case .delete:
            if self.sectionData[ip.section].count == 0 {
                self.sectionData.remove(at:ip.section)
                self.sectionNames.remove(at:ip.section)
                tableView.deleteSections(IndexSet(integer: ip.section),
                                         with:.automatic)
                tableView.reloadSectionIndexTitles()
            } else {
                tableView.deleteRows(at:[ip],
                                     with:UITableViewRowAnimation.automatic)
            }
        default: break
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let act = UITableViewRowAction(style: .normal, title: "Mark") {
            action, ip in
            print("Mark") // in real life, do something here
        }
        act.backgroundColor = .blue
        let act2 = UITableViewRowAction(style: .default, title: "Delete") {
            action, ip in
            self.tableView(self.tableView, commit:.delete, forRowAt:ip)
        }
        return [act2, act]
    }

    /// 防止滑动编辑 prevent swipe-to-edit
    //override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    //return self.isEditing ? .delete : .none
    //}


    // MARK: menu handling ==========

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    @nonobjc let copy = #selector(UIResponderStandardEditActions.copy)

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == copy
    }

    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == copy {
            print("copying \(self.sectionData[indexPath.section][indexPath.row])")
        }
    }
}
