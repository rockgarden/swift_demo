//
//  ViewController.swift
//  EventKitDemo
//
//  Created by wangkan on 2016/12/5.
//  Copyright © 2016年 rockgarden. All rights reserved.
//


import UIKit
import EventKit

class ViewController: UIViewController {

    /// 必须与App Build Settings 中的 Product Module Name 保持一致
    var database : EKEventStore {
        return EventKitDemo.database
    }

    @IBAction func doNewReminder (_ sender: Any!) {

        checkForEventAccess(.reminder) {

            do {

                let cal = self.database.defaultCalendarForNewReminders()

                let rem = EKReminder(eventStore: self.database)
                rem.title = "Get bread"
                rem.calendar = cal

                // reminder can have due date
                // let's make it today
                let today = Date()
                let greg = Calendar(identifier:.gregorian)
                // day without time means "all day"
                let comps : Set<Calendar.Component> = [.year, .month, .day]
                // start date not needed on iOS
                // rem.startDateComponents = [greg components:comps fromDate:today];
                rem.dueDateComponents = greg.dateComponents(comps, from:today)

                // let's add an alarm
                // interesting use of location: we can make a location-based alarm
                let alarm = EKAlarm()
                let loc = EKStructuredLocation(title:"Trader Joe's")
                loc.geoLocation = CLLocation(latitude:34.271848, longitude:-119.247714)
                loc.radius = 10*1000 // metres
                alarm.structuredLocation = loc
                alarm.proximity = .enter // "geofence": we alarm when *arriving*
                // but this will have no effect until Reminders is granted Location access...
                // and in iOS 8 it won't even ask for it until it is launched
                // also, in iOS 8 the separate background usage pref is withdrawn;
                // instead, auth of Reminders for "when in use" covers this...
                // ...because it means "this app *or one of its features* is visible on screen"
                rem.addAlarm(alarm)

                try self.database.save(rem, commit:true)
                print("no error")

            } catch {
                print("save calendar \(error)")
                return
            }


        }
    }
    
    
}
