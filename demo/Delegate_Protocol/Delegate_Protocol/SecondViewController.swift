//
//  SegundoViewController.swift
//  DelegateWithNavigator
//
//  Created by Carlos Butron on 02/12/14.
//  Copyright (c) 2015 Carlos Butron. All rights reserved.
//

import UIKit

protocol myDelegate {
    func writeDateInLabel(_ date: NSString)
}

class SecondViewController: UIViewController, myObjectDelegate {
    
    var data: NSString = ""
    var delegate: myDelegate?
    
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBAction func secondButton(_ sender: AnyObject) {
        self.delegate?.writeDateInLabel("I got it!")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myRequest: myObject = myObject()
        myRequest.delegate = self
        myRequest.start()
        secondLabel.text = data as String
    }
    
    func delegateMethod() {
        print("Received message")
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
