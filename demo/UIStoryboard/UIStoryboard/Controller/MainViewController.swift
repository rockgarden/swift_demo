//
//  MainViewController.swift
//  AHStoryboard
//
//  Created by Andyy Hope on 20/01/2016.
//  Copyright © 2016 Andyy Hope. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storyboard"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func pressMeForMagicButtonTapped(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(storyboard: .News)

        // Updated way
        let viewController: ArticleViewController = storyboard.instantiateViewController()
        
        viewController.printHeadline()
        
        present(viewController, animated: true, completion: nil)
    }
}
