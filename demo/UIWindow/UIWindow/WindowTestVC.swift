//
//  WindowTestVC.swift
//  UIWindow
//
//  Created by wangkan on 2016/11/3.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class WindowTestVC: UIViewController {

    private var nav: AppWindowNavVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var rightItem = UIBarButtonItem()
        rightItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(showBack))
        self.navigationItem.rightBarButtonItem = rightItem

        nav = self.navigationController as! AppWindowNavVC
        nav.setNavigationBarHidden(false, animated: false)
        
        let mainview = self.view
        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).cgColor
        lay1.frame = CGRect(x: 113, y: 111, width: 132, height: 194)
        mainview?.layer.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).cgColor
        lay2.frame = CGRect(x: 41, y: 56, width: 132, height: 194)
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        lay3.frame = CGRect(x: 43, y: 197, width: 160, height: 230)
        mainview?.layer.addSublayer(lay3)
    }

    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
        print(self.view.window!)
        print(UIApplication.shared.delegate!.window!!) // kind of wacky, there, Swift
        print((UIApplication.shared.delegate as! AppDelegate).window!)
        print(UIApplication.shared.keyWindow!)
        print(UIApplication.shared.windows.count) // prove there's just the one, ours
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func showBack() {
        nav.openAndClose()
    }

}

