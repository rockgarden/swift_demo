

import UIKit

class EditInsertAndRearrangeRowsVC: UITableViewController {

    var numbers = [String]()
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.name = "Matt Neuburg"
        self.numbers = ["(123) 456-7890"]
        tableView.allowsSelection = false

        tableView.register(UINib(nibName: "EIRRCell", bundle: nil), forCellReuseIdentifier: "EIRRCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.numbers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"EIRRCell",
                                                 for: indexPath) as! EIRRCell

        switch indexPath.section {
        case 0:
            cell.textField.text = self.name
        case 1:
            cell.textField.text = self.numbers[indexPath.row]
            cell.textField.keyboardType = .numbersAndPunctuation
        default: break
        }
        cell.textField.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 {
            let ct = self.tableView(tableView, numberOfRowsInSection:indexPath.section)
            if ct-1 == indexPath.row {
                return .insert
            }
            return .delete;
        }
        return .none
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Name"
        }
        return "Number"
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let s = self.numbers[fromIndexPath.row]
        self.numbers.remove(at:fromIndexPath.row)
        self.numbers.insert(s, at: toIndexPath.row)
        tableView.reloadData() // to get plus and minus buttons to redraw themselves
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        tableView.endEditing(true)
        if proposedDestinationIndexPath.section == 0 {
            return IndexPath(row:0, section:1)
        }
        return proposedDestinationIndexPath
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && self.numbers.count > 1 {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.endEditing(true) // user can click minus/plus while still editing
        // so we must force saving to the model
        if editingStyle == .insert {
            self.numbers += [""]
            let ct = self.numbers.count
            tableView.beginUpdates()
            tableView.insertRows(at:
                [IndexPath(row:ct-1, section:1)],
                                 with:.automatic)
            tableView.reloadRows(at:
                [IndexPath(row:ct-2, section:1)],
                                 with:.automatic)
            tableView.endUpdates()
            // crucial that this next bit be *outside* the updates block
            let cell = self.tableView.cellForRow(at:
                IndexPath(row:ct-1, section:1))
            (cell as! EIRRCell).textField.becomeFirstResponder()
        }
        if editingStyle == .delete {
            self.numbers.remove(at:indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at:
                [indexPath], with:.automatic)
            tableView.reloadSections(
                IndexSet(integer:1), with:.automatic)
            tableView.endUpdates()
        }
    }
    
}


extension EditInsertAndRearrangeRowsVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // some cell's text field has finished editing; which cell?
        var v : UIView = textField
        repeat { v = v.superview! } while !(v is UITableViewCell)
        // another way to say:
        //        var v : UIView
        //        for v = textField; !(v is UITableViewCell); v = v.superview! {}
        let cell = v as! EIRRCell
        // update data model to match
        let ip = self.tableView.indexPath(for:cell)!
        if ip.section == 1 {
            self.numbers[ip.row] = cell.textField.text!
        } else if ip.section == 0 {
            self.name = cell.textField.text!
        }
    }

}
