

import UIKit

class CellMenusVC : AppTableVC {

    //override var nibName : String { return "RootViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MenuCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! MenuCell
        let s = self.sectionData[indexPath.section][indexPath.row]
        cell.textLabel!.text = s

        var stateName = s
        stateName = stateName.lowercased()
        stateName = stateName.replacingOccurrences(of:" ", with:"")
        stateName = "flag_\(stateName).gif"
        let im = UIImage(named: stateName)
        cell.imageView!.image = im
        
        return cell
    }
    
    // MARK: custom menu handling ==========
    
    @nonobjc let copy = #selector(UIResponderStandardEditActions.copy)
    @nonobjc let abbrev = #selector(MenuCell.abbrev)

    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let mi = UIMenuItem(title: "Abbrev", action: abbrev)
        UIMenuController.shared.menuItems = [mi]
        return true
    }

    override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == copy || action == abbrev
    }
    
    override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == copy {
            print("copying \(self.sectionData[indexPath.section][indexPath.row])")
        }
        if action == abbrev {
            print("abbreviating \(self.sectionData[indexPath.section][indexPath.row])")
        }
    }
}


private class MenuCell : UITableViewCell {

    @objc func abbrev(_ sender: Any?) {
        // find my table view
        var v : UIView = self
        repeat {v = v.superview!} while !(v is UITableView)
        let tv = v as! UITableView
        // ask it what index path we are
        let ip = tv.indexPath(for: self)!
        // talk to its delegate
        tv.delegate?.tableView?(tv, performAction:#selector(abbrev), forRowAt:ip, withSender:sender)
    }

}
