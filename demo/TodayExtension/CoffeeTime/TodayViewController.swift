//
//  TodayViewController.swift
//  CoffeeTime
//
//  Created by wangkan on 2016/10/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//  http://www.raywenderlich.com/83809/ios-8-today-extension-tutorial

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    let dateKey = "COUNTDOWN_DATE"
    var endDate = Date().addingTimeInterval(60*60*10)
    fileprivate var taskManager = Timer()
    
    required init?(coder: NSCoder) {
        NSLog("init")
        super.init(coder:coder)
    }

    override func awakeFromNib() {
        NSLog("awake")
        super.awakeFromNib()
        // self.preferredContentSize = CGSizeMake(320,113)
        // let v = UIVisualEffectView(effect: UIVibrancyEffect.notificationCenterVibrancyEffect())
        guard let date = loadDateIfSaved() else {
            self.dateLabel.text = "No Date to count from."
            return
        }
        endDate = date
        taskManager = Timer(timeInterval: 1, target: self, selector: #selector(TodayViewController.updateCountDown), userInfo: nil, repeats: true)
        RunLoop.main.add(taskManager, forMode: .commonModes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.preferredContentSize = CGSizeMake(320,113)
        self.iv.image = UIImage(named:"cup.png")?.withRenderingMode(.alwaysTemplate)
    }
    
    /// After updating the constraint, you must reload the chart’s data so that it redraws based on the new layout.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //update view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        taskManager.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadDateIfSaved() -> Date? {
        let usrDefaults = UserDefaults.standard
        guard let date = usrDefaults.object(forKey: dateKey) else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            guard let christmas = dateFormatter.date(from: "25/12/2016") else {
                return nil
            }
            usrDefaults.set(christmas, forKey: dateKey)
            return christmas
        }
        return date as? Date
    }

    func updateCountDown() {
        let currentDate = Date()
        let timeInterval = Int(endDate.timeIntervalSince(currentDate as Date))
        let min = 60
        let hour = 60*min
        let day = 24*hour
        let days = timeInterval / day
        let hours = (timeInterval % day) / hour
        let mins = (timeInterval % hour) / min
        let seconds = timeInterval % min
        self.dateLabel.text = "\(days) days \(hours) hours \(mins) minutes \(seconds) seconds"
    }

    /// 怎么调试
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
        let url = URL(string: "todolist://add")
        self.extensionContext?.open(url!, completionHandler: nil)
        /// self.extensionContext其实就是Today这个app,然后有Today和主应用进行进程间通讯,就是OpenUrl
//        if (button.tag == 1) {
//            [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoHomePage"] completionHandler:^(BOOL success) {
//                NSLog(@"open url result:%d",success);
//                }];
//        }
//        else if(button.tag == 2) {
//            [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoOrderPage"] completionHandler:^(BOOL success) {
//                NSLog(@"open url result:%d",success);
//                }];
//        }
    }

    /// 自定义边距 改变默认缩进的法
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,16,0,16)
    }
    
//    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
//        NSLog("performUpdate")
//        completionHandler(NCUpdateResult.newData)
//    }

    /// 更新插件
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        NSLog("performUpdate")
        // Perform any setup necessary in order to update the view.
        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }

}
