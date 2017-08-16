//
//  DetailViewController.swift
//  UISplitViewControllerDemo
//
//  Created by wangkan on 2017/8/16.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var lab : UILabel!
    var boy : String = "" {
        didSet {
            if self.lab != nil {
                self.lab.text = self.boy
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lab)
        NSLayoutConstraint.activate([
            lab.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            lab.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        self.lab = lab
        self.lab.text = self.boy

        let b = UIBarButtonItem(title: "SplitViewControllerManual", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showManualSVC))
        navigationItem.rightBarButtonItem = b
    }

    @objc private func showManualSVC() {
        let vc = SplitViewControllerManual()
        present(vc, animated: true, completion: nil)
    }

    deinit {
        print("farewell from detail view controller")
    }

    /// Start from Storyboard
    //    @IBOutlet weak var detailDescriptionLabel: UILabel!
    //
    //    func configureView() {
    //        // Update the user interface for the detail item.
    //        if let detail = detailItem {
    //            if let label = detailDescriptionLabel {
    //                label.text = detail.description
    //            }
    //        }
    //    }
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view, typically from a nib.
    //        configureView()
    //    }
    //
    //    var detailItem: NSDate? {
    //        didSet {
    //            // Update the view.
    //            configureView()
    //        }
    //    }
    
    
}

