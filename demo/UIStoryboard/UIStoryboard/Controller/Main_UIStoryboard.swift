//
//  MainViewController.swift
//  AHStoryboard
//
//  Created by Andyy Hope on 20/01/2016.
//  Copyright © 2016 Andyy Hope. All rights reserved.
//

import UIKit

class Main_UIStoryboard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storyboard"
    }

    @IBAction func pressMeForMagicButtonTapped(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(storyboard: .News)

        // Updated way
        let viewController: ArticleViewController = storyboard.instantiateViewController()
        
        viewController.printHeadline()
        
        present(viewController, animated: true, completion: nil)
    }

    @IBAction func unwindStoryboardMain (_ sender: UIStoryboardSegue) {
        debugPrint(sender)
    }
}
