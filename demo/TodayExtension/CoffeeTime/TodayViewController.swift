//
//  TodayViewController.swift
//  CoffeeTime
//
//  Created by wangkan on 2016/10/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var iv: UIImageView!

    required init?(coder: NSCoder) {
        NSLog("init")
        super.init(coder:coder)
    }

    override func awakeFromNib() {
        NSLog("awake")
        super.awakeFromNib()
        // self.preferredContentSize = CGSizeMake(320,113)
        // let v = UIVisualEffectView(effect: UIVibrancyEffect.notificationCenterVibrancyEffect())

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.preferredContentSize = CGSizeMake(320,113)
        self.iv.image = UIImage(named:"cup.png")?.withRenderingMode(.alwaysTemplate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doButton(_ sender: AnyObject) {
        NSLog("doButton")
        let v = sender as! UIView
        var comp = URLComponents()
        comp.scheme = "coffeetime"
        comp.host = String(v.tag) // tag is number of minutes
        if let url = comp.url(relativeTo: nil) {
            NSLog("%@", "\(url)")
            self.extensionContext?.open(url, completionHandler: nil)
        }
    }

    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,16,0,16)
    }
    
    private func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        NSLog("performUpdate")
        completionHandler(NCUpdateResult.newData)
    }

//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        NSLog("performUpdate")
//        // Perform any setup necessary in order to update the view.
//
//        // If an error is encoutered, use NCUpdateResult.Failed
//        // If there's no update required, use NCUpdateResult.NoData
//        // If there's an update, use NCUpdateResult.NewData
//
//        completionHandler(NCUpdateResult.newData)
//    }

}
