//
//  ViewController.swift
//  UIViewController
//
//  Created by wangkan on 2017/4/8.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class UnderlappingVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view)
        print(self.nibName as Any)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(self.view.bounds.size)
        print(self.navigationController!.view.bounds.size)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        func reset(_ cm : inout CellModel) {
            cm.visible = true
        }
        for ix in self.model.indices {reset(&self.model[ix])}
        self.tableView.reloadData()

        // rest is just interesting logging
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
        // to see this, turn off our animation and use the pop gesture
        let tc = self.transitionCoordinator

        if #available(iOS 10.0, *) {
            tc?.notifyWhenInteractionChanges { ctx in
                if ctx.isCancelled {
                    print("we got cancelled")
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)

        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
    }

    private var hide = false

    override var prefersStatusBarHidden : Bool {
        return self.hide
    }

    @IBAction func doButton(_ sender: Any) {
        self.hide = !self.hide
        UIView.animate(withDuration:0.4) {
            /// Ask the system to re-query our -preferredStatusBarStyle.
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }
    }

    struct CellModel {
        let name = "poppy" // hard-coded; well it's only an example
        var visible = true
    }

    var model = [CellModel()] // only one row; I _said_ it's only an example

    var lastSelection = IndexPath()

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCell
        let cm = self.model[indexPath.row]
        cell.iv.image = UIImage(named:cm.name)
        if !cm.visible {
            cell.iv.image = nil
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.model[indexPath.row].visible = false
        tableView.reloadRows(at: [indexPath], with: .none)
        self.lastSelection = indexPath
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.tableView.indexPathForSelectedRow as Any)
        if let dest = segue.destination as? DetailViewController {
            let cm = self.model[self.lastSelection.row]
            dest.detailItem = UIImage(named:cm.name)
        }
    }
}


/// FIXME: can't define private
class MyCell : UITableViewCell {
    @IBOutlet weak var iv : UIImageView!
}


class DetailViewController : UIViewController {
    var detailItem : Any?
    @IBOutlet var iv : UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let im = self.detailItem as? UIImage {
            self.iv.image = im
        }
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
    }
}
