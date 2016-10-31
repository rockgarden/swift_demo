//
//  ViewController.swift
//  Notification
//
//  Created by wangkan on 16/8/19.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import MediaPlayer

let which = 2 // 1 or 2

class ViewController: UIViewController {

    var observers = Set<NSObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testUILocalNotification()
        self.singleTap(self)
        //FIXME: MPMusicPlayerController: Server is not running, deferring check-in
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.beginGeneratingPlaybackNotifications()

        switch which {
        case 1:
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(nowPlayingItemChanged),
                                                   name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                                                   object: nil)
        case 2:
            let ob = NotificationCenter.default
                .addObserver(
                    forName: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                    object: nil, queue: nil) {
                        _ in
                        print("changed")
            }
            self.observers.insert(ob as! NSObject)
        default: break
        }

    }

    func nowPlayingItemChanged (_ n: Notification) {
        print("changed")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        switch which {
        case 1:
            NotificationCenter.default.removeObserver(self)
        case 2:
            for ob in self.observers {
                NotificationCenter.default.removeObserver(ob)
            }
            self.observers.removeAll()
        default:break
        }
        let mp = MPMusicPlayerController.systemMusicPlayer()
        mp.endGeneratingPlaybackNotifications()
    }

    func singleTap(_:AnyObject) {
        NotificationCenter.default
            .post(name: Notification.Name(rawValue: "cardTapped"), object: self)
    }

    // when app is already in the foreground, testUILocalNotification() show the notification delay TimeInterval(10)."
    /**
     Note from https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html:
     */
    func testUILocalNotification() {
        let notification = UILocalNotification()
        notification.fireDate = Date().addingTimeInterval(10)
        notification.alertBody = "Alert"
        UIApplication.shared.scheduleLocalNotification(notification)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    func keyboardWillAppear(_ notification: Foundation.Notification) {
        print("Show Keyboard")
    }
    
    func keyboardWillDisappear(_ notification:Foundation.Notification){
        print("Hide Keyboard")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlternate" {
            if let dest = segue.destination as? FlipsideViewController {
                dest.delegate = self
            }
        }
    }
    
}

extension ViewController: FlipsideViewControllerDelegate {
    func flipsideViewControllerDidFinish(_ controller: FlipsideViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
