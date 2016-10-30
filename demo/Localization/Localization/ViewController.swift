//
//  ViewController.swift
//  Localization
//
//  Created by wangkan on 2016/10/30.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender:AnyObject) {
        let alert = UIAlertController(
            title: NSLocalizedString("ATitle", comment:"Howdy!"),
            message: NSLocalizedString("AMessage", comment:"You tapped me!"),
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Accept", comment:"OK"),
                          style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

