//
//  PopoverViewController.swift
//  AlertVSPopoverWithTextView
//
//  Created by Rumiya Murtazina on 6/30/16.
//  Copyright © 2016 abearablecode. All rights reserved.
//

import UIKit

class PopoverVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onOKButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
