//
//  ViewController.swift
//  UIViewController
//
//  Created by wangkan on 2017/4/8.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class UnderlappingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view)
        print(self.nibName as Any)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(self.view.bounds.size)
        print(self.navigationController!.view.bounds.size)
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

}

