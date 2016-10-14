//
//  MenuViewController.swift
//  TumblrMenu
//
//  Created by Allen on 16/1/24.
//  Copyright © 2016年 Allen. All rights reserved.
//

// 关闭 MenuViewController
//@IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
//    self.dismissViewControllerAnimated(true, completion: nil)
//}

import UIKit

class MenuViewController: UIViewController {
    
    let transitionManager = MenuTransitionManager()
    
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    
    @IBOutlet weak var quoteButton: UIButton!
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var linkLabel: UILabel!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var chatLabel: UILabel!
    
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var audioLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self.transitionManager
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
