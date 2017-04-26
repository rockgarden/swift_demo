//
//  ViewController.swift
//  SwipeBetweenViewControllers
//
//  Created by Marek Fořt on 14.03.16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit

class SwipeVC: SwipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let VC1 = UIViewController()
        VC1.view.backgroundColor = UIColor(red: 0.19, green: 0.36, blue: 0.60, alpha: 1.0)
        VC1.title = "Recent"
        let VC2 = UIViewController()
        VC2.view.backgroundColor = UIColor(red: 0.70, green: 0.23, blue: 0.92, alpha: 1.0)
        VC2.title = "Favourite"
        let VC3 = UIViewController()
        VC3.view.backgroundColor = UIColor(red: 0.17, green: 0.70, blue: 0.27, alpha: 1.0)
        VC3.title = "Trending"
        let VC4 = UIViewController()
        VC3.view.backgroundColor = UIColor(red: 0.37, green: 0.40, blue: 0.27, alpha: 1.0)
        VC3.title = "Other"
        
        
        setViewControllerArray([VC1, VC2, VC3, VC4])
        setFirstViewController(0)
        setSelectionBar(80, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 18), color: UIColor.black, selectedColor: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        equalSpaces = false
        
        //Button with image example
        //let buttonOne = SwipeButtonWithImage(image: UIImage(named: "Hearts"), selectedImage: UIImage(named: "YellowHearts"), size: CGSize(width: 40, height: 40))
        //setButtonsWithImages([buttonOne, buttonOne, buttonOne])
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
        setNavigationWithItem(UIColor.white, leftItem: barButtonItem, rightItem: nil)
        
    }
    
    func push(sender: UIBarButtonItem) {
        let VC4 = UIViewController()
        VC4.view.backgroundColor = UIColor.purple
        VC4.title = "Cool"
        self.pushViewController(VC4, animated: true)
    }
    
    
}
