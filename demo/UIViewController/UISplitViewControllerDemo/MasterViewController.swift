//
//  MasterViewController.swift
//  UISplitViewControllerDemo
//
//  Created by wangkan on 2017/8/16.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let model = ["Manny", "Moe", "Jack"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        print(self.splitViewController?.childViewControllers as Any)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        cell.textLabel!.text = model[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        detail.boy = model[indexPath.row]
        let b = self.splitViewController?.displayModeButtonItem
        detail.navigationItem.leftBarButtonItem = b
        detail.navigationItem.leftItemsSupplementBackButton = true

        let nav = UINavigationController(rootViewController: detail)
        self.showDetailViewController(nav, sender: self)

        let del = UIApplication.shared.delegate as! AppDelegate
        del.didChooseDetail = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// logging to show that I'm right to describe the detail view controller as "jettisoned". it is not _released_, but that's an internal implementation detail: the split view controller keeps it in its `__preservedDetailController` property
        print(self.splitViewController?.childViewControllers as Any)

    }

    /// Start from Storyboard
    //    var detailViewController: DetailViewController? = nil
    //    var objects = [Any]()
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view, typically from a nib.
    //        navigationItem.leftBarButtonItem = editButtonItem
    //
    //        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    //        navigationItem.rightBarButtonItem = addButton
    //        if let split = splitViewController {
    //            let controllers = split.viewControllers
    //            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    //        }
    //    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    //        super.viewWillAppear(animated)
    //    }
    //
    //    func insertNewObject(_ sender: Any) {
    //        objects.insert(NSDate(), at: 0)
    //        let indexPath = IndexPath(row: 0, section: 0)
    //        tableView.insertRows(at: [indexPath], with: .automatic)
    //    }
    //
    //    // MARK: - Segues
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "showDetail" {
    //            if let indexPath = tableView.indexPathForSelectedRow {
    //                let object = objects[indexPath.row] as! NSDate
    //                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
    //                controller.detailItem = object
    //                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    //                controller.navigationItem.leftItemsSupplementBackButton = true
    //            }
    //        }
    //    }
    //
    //    // MARK: - Table View
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return objects.count
    //    }
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    //
    //        let object = objects[indexPath.row] as! NSDate
    //        cell.textLabel!.text = object.description
    //        return cell
    //    }
    //
    //    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return true
    //    }
    //
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            objects.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        } else if editingStyle == .insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    //        }
    //    }
    
}

