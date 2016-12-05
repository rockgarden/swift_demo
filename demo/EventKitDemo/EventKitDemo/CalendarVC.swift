//
//  CalendarVC.swift
//  EventKitDemo
//
//  Created by wangkan on 2016/12/5.
//  Copyright © 2016年 rockgarden. All rights reserved.
//


import UIKit
import EventKit
import EventKitUI

class CalendarVC: UIViewController, EKEventViewDelegate, EKEventEditViewDelegate, EKCalendarChooserDelegate {
    var napid : String!

    var database : EKEventStore {
        return EventKitDemo.database
    }

    @IBAction func createCalendar (_ sender: Any!) {
        checkForEventAccess(.event) {
            guard (self.calendar(name: "CoolCal") != nil) else {return}
            do {
                /// obtain local source 是错误的方法, 因为如果用户启用 icloud 日历功能 EKEventStore 返回的默认类型是 EKSourceType.calDAV, 反之才会返回 local. 所以正确获得sources 的方法是 defaultCalendarForNewEvents.source, 相当于反射.
                //let locals = self.database.sources.filter {$0.sourceType == .local}
                //guard let src = locals.first else {return}

                let cal = EKCalendar(for:.event, eventStore:self.database)
                // It will fetch the default source if iCloud is on the it will fetch
                cal.source = self.database.defaultCalendarForNewEvents.source
                cal.title = "CoolCal"
                // ready to save the new calendar into the database!
                try self.database.saveCalendar(cal, commit:true)
                print("no errors")
            } catch {
                print("save calendar error: \(error)")
                return
            }
        }
    }

    /**
     this method is used to fetch the calendar
     - parameter name: any string which is exist on calendar
     - returns: calendar object
     */
    func calendar(name:String) -> EKCalendar? {
        let cals = self.database.calendars(for:.event)
        return cals.filter {$0.title == name}.first
    }

    @IBAction func createSimpleEvent (_ sender: Any!) {

        checkForEventAccess(.event) {
            do {
                debugPrint(self.calendar)
                guard let cal = self.calendar(name: "CoolCal") else {
                    print("failed to find calendar")
                    return
                }
                // form the start and end dates
                let greg = Calendar(identifier:.gregorian)
                var comp = DateComponents(year:2016, month:8, day:10, hour:15)
                let d1 = greg.date(from:comp)!
                comp.hour = comp.hour! + 1
                let d2 = greg.date(from:comp)!

                // form the event
                let ev = EKEvent(eventStore:self.database)
                ev.title = "Take a nap"
                ev.notes = "You deserve it!"
                ev.calendar = cal
                (ev.startDate, ev.endDate) = (d1,d2)

                // we can also easily add an alarm
                let alarm = EKAlarm(relativeOffset:-3600) // one hour before
                ev.addAlarm(alarm)

                // save it
                try self.database.save(ev, span:.thisEvent, commit:true)
                print("no errors")

            } catch {
                print("save simple event \(error)")
                return
            }


        }
    }

    @IBAction func createRecurringEvent (_ sender: Any!) {

        checkForEventAccess(.event) {

            do {

                guard let cal = self.calendar(name:"CoolCal") else {
                    print("failed to find calendar")
                    return
                }

                let everySunday = EKRecurrenceDayOfWeek(.sunday)
                let january = 1 as NSNumber
                let recur = EKRecurrenceRule(
                    recurrenceWith:.yearly, // every year
                    interval:2, // no, every *two* years
                    daysOfTheWeek:[everySunday],
                    daysOfTheMonth:nil,
                    monthsOfTheYear:[january],
                    weeksOfTheYear:nil,
                    daysOfTheYear:nil,
                    setPositions: nil,
                    end:nil)

                let ev = EKEvent(eventStore:self.database)
                ev.title = "Mysterious biennial Sunday-in-January morning ritual"
                ev.addRecurrenceRule(recur)
                ev.calendar = cal
                // need a start date and end date
                let greg = Calendar(identifier:.gregorian)
                var comp = DateComponents(year:2016, month:1, hour:10)
                comp.weekday = 1 // Sunday
                comp.weekdayOrdinal = 1 // *first* Sunday
                ev.startDate = greg.date(from:comp)!
                comp.hour = 11
                ev.endDate = greg.date(from:comp)!

                try self.database.save(ev, span:.futureEvents, commit:true)
                print("no errors")

            } catch {
                print("save recurring event \(error)")
                return
            }


        }

    }

    @IBAction func searchByRange (_ sender: Any!) {

        checkForEventAccess(.event) {

            guard let cal = self.calendar(name:"CoolCal") else {
                print("failed to find calendar")
                return
            }

            let greg = Calendar(identifier:.gregorian)
            let d = Date() // today
            let d1 = greg.date(byAdding:DateComponents(year:-1), to:d)!
            let d2 = greg.date(byAdding:DateComponents(year:2), to:d)!
            let pred = self.database.predicateForEvents(withStart:
                d1, end:d2, calendars:[cal])
            DispatchQueue.global(qos:.default).async {
                var events = [EKEvent]()
                self.database.enumerateEvents(matching:pred) { ev, stop in
                    events += [ev]
                    if ev.title.range(of:"nap") != nil {
                        self.napid = ev.calendarItemIdentifier
                        print("found the nap")
                        stop.pointee = true
                    }
                }
                events.sort { $0.compareStartDate(with:$1) == .orderedAscending }

                print(events)
                print(events.map {$0.calendarItemIdentifier})


            }

        }
    }

    // ========

    var napEvent : EKEvent!

    @IBAction func showEventUI (_ sender: Any!) {
        checkForEventAccess(.event) {

            if self.napid == nil {
                print("need to search for nap event first")
                return
            }
            let ev = self.database.calendarItem(withIdentifier:self.napid) as! EKEvent

            let evc = EKEventViewController()
            evc.event = ev
            evc.allowsEditing = false
            evc.delegate = self
            // big big change
            self.navigationController?.pushViewController(evc, animated: true)
            //        let nav = UINavigationController(rootViewController: evc)
            //        nav.modalPresentationStyle = .popover
            //        self.present(nav, animated: true)
            //        if let pop = nav.popoverPresentationController {
            //            if let v = sender as? UIView {
            //                pop.sourceView = v
            //                pop.sourceRect = v.bounds
            //            }
            //        }

        }
    }

    func eventViewController(_ controller: EKEventViewController,
                             didCompleteWith action: EKEventViewAction) {
        print("did complete with action \(action.rawValue)")
        if action == .deleted { // _ = in next line is due to optional, I regard as bug
            // changing to forced unwrap to avoid that
            self.navigationController!.popViewController(animated:true)
        }
    }

    // ========

    @IBAction func editEvent (_ sender: Any!) {
        checkForEventAccess(.event) {

            let evc = EKEventEditViewController()
            evc.eventStore = self.database
            evc.editViewDelegate = self
            evc.modalPresentationStyle = .popover
            self.present(evc, animated: true)
            if let pop = evc.popoverPresentationController {
                if let v = sender as? UIView {
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            }

        }
    }

    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        print("did complete: \(action.rawValue), \(controller.event)")
        self.dismiss(animated:true)
    }

    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return self.calendar(name:"CoolCal")!
    }

    // ===============

    @IBAction func deleteCalendar (_ sender: Any!) {
        checkForEventAccess(.event) {

            let choo = EKCalendarChooser(
                selectionStyle:.single,
                displayStyle:.allCalendars,
                entityType:.event,
                eventStore:self.database)
            choo.showsDoneButton = true
            choo.showsCancelButton = true
            choo.delegate = self
            choo.navigationItem.prompt = "Pick a calendar to delete:"
            let nav = UINavigationController(rootViewController: choo)
            nav.modalPresentationStyle = .popover
            self.present(nav, animated: true)
            if let pop = nav.popoverPresentationController {
                if let v = sender as? UIView {
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            }

        }
    }

    // need delegate methods in order to dismiss

    func calendarChooserDidCancel(_ choo: EKCalendarChooser) {
        self.dismiss(animated:true)
    }

    func calendarChooserDidFinish(_ choo: EKCalendarChooser) {
        let cals = choo.selectedCalendars
        guard cals.count > 0 else { self.dismiss(animated:true); return }
        let calsToDelete = cals.map {$0.calendarIdentifier}
        let alert = UIAlertController(title:"Delete selected calendar?",
                                      message:nil, preferredStyle:.actionSheet)
        alert.addAction(UIAlertAction(title:"Cancel", style:.cancel))
        alert.addAction(UIAlertAction(title:"Delete", style:.destructive) {_ in
            for id in calsToDelete {
                if let cal = self.database.calendar(withIdentifier:id) {
                    try? self.database.removeCalendar(cal, commit: true)
                }
            }
            self.dismiss(animated:true) // dismiss *everything*
        })
        // alert sheet inside presented-or-popover
        choo.present(alert, animated: true)
    }
}

