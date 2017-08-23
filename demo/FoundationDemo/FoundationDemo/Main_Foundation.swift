//
//  Main_Foundation.swift
//  FoundationDemo
//


import UIKit

class Main_Foundation: UITableViewController {

    var sectionHeaders: Array<String>!
    var sectionDatas: Array<Array<(title:String, class:String, sb:String)>>!
    var sectionClasses: Array<Array<String>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableData()
    }

    func initTableData() {
        sectionHeaders = ["无分类",]
        let d1 = [
            (title: "UndoManager Demo", class:"UndoManagerVC", sb:"UndoManager"),
            ]
        sectionDatas = [d1,]
    }

    //MARK:- TableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionDatas.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)

        let d = self.sectionDatas[indexPath.section][indexPath.row]
        if d.sb != "" {
            let vc = UIStoryboard(name: d.sb, bundle: nil).instantiateViewController(withIdentifier: d.class)
            show(vc, sender: nil)
        } else {

        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDef = self.sectionDatas[section]
        return sectionDef.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    //MARK:- TableViewDataSource
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "demoCellIdentifier"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {

            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }

        let d = self.sectionDatas[indexPath.section][indexPath.row]

        cell!.textLabel?.text = d.title
        cell!.detailTextLabel?.text = d.class

        return cell!
    }
}
