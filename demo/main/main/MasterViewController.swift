//
//  MasterViewController.swift
//  KBKit
//
//  Created by Evan Dekhayser on 12/13/15.
//  Copyright © 2015 Evan Dekhayser. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = [AnyObject]()

    override var keyCommands: [UIKeyCommand]?{
        let addCommand = UIKeyCommand(input: "+", modifierFlags: [], action: #selector(MasterViewController.insertNewObject(_:)), discoverabilityTitle: "Add")
        let editCommand = UIKeyCommand(input: "e", modifierFlags: [.command], action: #selector(MasterViewController.editToggled), discoverabilityTitle: "Edit")
        return [addCommand, editCommand]
    }
    
    fileprivate lazy var methodToCallWhenEditingDisabled: (IndexPath) -> Void = { indexPath in
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    fileprivate lazy var methodToCallWhenEditingEnabled: (IndexPath) -> Void = { indexPath in
        self.tableView(self.tableView, commit: .delete, forRowAt: indexPath)
    }
    
    func editToggled(){
        isEditing = !isEditing
        if let tableView = tableView as? KBTableView{
            tableView.onSelection = isEditing ? methodToCallWhenEditingEnabled : methodToCallWhenEditingDisabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MasterViewController.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        if let tableView = tableView as? KBTableView {
            tableView.onSelection = isEditing ? methodToCallWhenEditingEnabled : methodToCallWhenEditingDisabled
			tableView.onFocus = { current, previous in
				if let current = current{
					tableView.cellForRow(at: current as IndexPath)?.isHighlighted = true
				}
				if let previous = previous{
					tableView.cellForRow(at: previous as IndexPath)?.isHighlighted = false
				}
			}
        }
        
        tableView.becomeFirstResponder()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.becomeFirstResponder()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: AnyObject) {
        objects.insert(Date() as AnyObject, at: 0)
		self.tableView.reloadData()
	}

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[(indexPath as NSIndexPath).row] as! Date
                let controller = segue.destination as! DetailViewController
                controller.detailItem = object as AnyObject?
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[(indexPath as NSIndexPath).row] as! Date
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let tableView = tableView as? KBTableView{
                tableView.stopHighlighting()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

