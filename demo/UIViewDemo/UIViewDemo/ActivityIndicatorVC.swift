//
//  ViewController.swift
//  libTest
//
//  Created by abdul karim on 25/12/15.
//  Copyright © 2015 dhlabs. All rights reserved.
//

import UIKit

class ActivityIndicatorVC: UIViewController {
    
    var tapCount = 0
    
    @IBOutlet weak var activityView: activityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // activityView.lineWidth = 2
    }
    
    @IBAction func startAction(sender: AnyObject) {
        activityView.startLoading()
    }
    
    @IBAction func progressAction(sender: AnyObject) {
        let progress: Float = activityView.progress + 0.1043
        activityView.progress = progress
    }
    
    @IBAction func successAction(sender: AnyObject) {
        activityView.startLoading()
        activityView.completeLoading(true)
    }
    
    @IBAction func unsucessAct(sender: AnyObject) {
        activityView.startLoading()
        activityView.strokeColor = UIColor.red
        activityView.completeLoading(false)
    }
    
    @IBAction func changeColorAct(sender: AnyObject) {
        tapCount += 1
        
        if (tapCount == 1){
            activityView.strokeColor = UIColor.red
        }
        else
            if (tapCount == 2) {
                activityView.strokeColor = UIColor.black
            }
            else
                if (tapCount == 3) {
                    tapCount = 0
                    activityView.strokeColor = UIColor.purple
                    
        }
    }
    
}

