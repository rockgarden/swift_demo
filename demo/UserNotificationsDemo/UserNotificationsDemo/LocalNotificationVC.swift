
import UIKit
import UserNotifications

class MyUserNotificationHelper : NSObject {
    let categoryIdentifier = "coffee"

    func kickThingsOff() {
        /// Artificially, I'm going to start by clearing out any categories. otherwise, it's hard to test, because even after deleting the app, the categories stick around and continue to be used
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([])

        /// iOS 10功能: 我们不需要人为地清除所有的通知. Not so artificially, before we do anything else let's clear out all notifications.
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        self.checkAuthorization()
    }

    private func checkAuthorization() {
        print("checking for notification permissions")

        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {
            settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.doAuthorization()
            case .denied:
                print("denied, giving up")
            break // nothing to do, pointless to go on
            case .authorized:
                self.checkCategories() // prepare create notification
            }
        }
    }

    private func doAuthorization() {
        print("asking for authorization")

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { ok, err in
            if let err = err {
                print(err)
                return
            }
            if ok {
                self.checkCategories()
            } else {
                print("user refused authorization")
            }
        }
    }

    private func checkCategories() {
        print("checking categories")

        let center = UNUserNotificationCenter.current()
        center.getNotificationCategories {
            cats in
            if cats.count == 0 {
                self.configureCategory()
            }
            self.createNotification()
        }
    }

    /// how action buttons are displayed: if the device has 3D touch, must 3D touch.
    /// otherwise: for a banner/alert: there is a "drag" bar and you drag downward in the notification center, then you drag left and there is a View button, tap it.

    private func configureCategory() {
        // return // see what it's like if there's no category
        print("configuring category")

        /// Create actions
        /// - UNNotificationActionOptions:
        ///   - foreground (if not, background)
        ///   - destructive (if not, normal appearance)
        ///   - authenticationRequired (if so, cannot just do directly from lock screen如果是，不能直接从锁定屏幕执行)
        let action1 = UNNotificationAction(identifier: "snooze", title: "Snooze")
        let action2 = UNNotificationAction(identifier: "reconfigure",
                                           title: "Reconfigure", options: [.foreground])
        let action3 = UNTextInputNotificationAction(identifier: "message", title: "Message", options: [], textInputButtonTitle: "Message", textInputPlaceholder: "message")

        /// Combine actions into category 将动作组合到类别中
        /// The key UNNotificationCategoryOptions here is customDismissAction - allows us to hear about it if user dismisses. if we don't have this, we won't hear about it when user dismisses
        var customDismiss : Bool { return false }
        let cat = UNNotificationCategory(identifier: self.categoryIdentifier, actions: [action1, action2], intentIdentifiers: [], options: customDismiss ? [.customDismissAction] : [])
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([cat])

        _ = action3
    }

    fileprivate func createNotification() {
        print("creating notification")

        // need trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        // need content
        let content = UNMutableNotificationContent()
        content.title = "Caffeine!" // title now always appears
        // content.subtitle = "whatever" // new
        content.body = "Time for another cup of coffee!"
        content.sound = UNNotificationSound.default()

        // if we want to see actions, we must add category identifier
        content.categoryIdentifier = self.categoryIdentifier

        // new iOS 10 feature: attachments! AIFF, JPEG, or MPEG
        let url = Bundle.main.url(forResource: "cup2", withExtension: "jpg")!

        // FIXME: a failed experiment
        //let rect = CGRect(0,0,1,1).dictionaryRepresentation
        //let dict : [AnyHashable:Any] = [UNNotificationAttachmentOptionsThumbnailClippingRectKey:rect]

        if let att = try? UNNotificationAttachment(identifier: "cup", url: url, options:nil) {
            content.attachments = [att]
        } else {
            print("failed to make attachment")
        }

        //            let url = Bundle.main.url(forResource: "test", withExtension: "aif")!
        //            if let att2 = try? UNNotificationAttachment(identifier: "test", url: url) {
        //                content.attachments = [att2] // I tried [att, att2] but there was no interface for the sound
        //                // so, despite the name, I suggest having only one attachment!
        //            } else {
        //                print("failed to make second attachment")
        //            }

        /// Combine them into a request
        let req = UNNotificationRequest(identifier: "coffeeNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(req)
    }
}

extension MyUserNotificationHelper : UNUserNotificationCenterDelegate {

    /// called if we are in the foreground when our notification fires
    /// 在iOS 10 中新增，我们可以选择让系统显示通知！一种或另一种方式，但是，我们调用completionHandler. 
    /// 当通知发送到前台应用程序时调用。如果您的应用在通知到达时处于前台，则通知中心会调用此方法将该通知直接发送到您的应用。如果您实现此方法，您可以采取任何必要的操作来处理通知并更新您的应用程序。完成后，执行completionHandler块，并指定系统如何提醒用户（如果有的话）。 如果您的代理没有实现此方法，则系统会使警报静默，就像您已将UNNotificationPresentationOptionNone选项传递给completionHandler块一样。如果您没有为UNUserNotificationCenter对象提供委托，系统将使用通知的原始选项来提醒用户。
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("received notification while active")

        completionHandler([.sound, .alert]) // go for it, system!

        /// 如果打开 请勿打扰，则不会有通知中断, 他们进入通知中心，但它们不会出现在正常界面中。
        /// if Do Not Disturb is on, no notifications interrupt, they go in notification center but they don't appear in normal interface
    }

    /// 发生的一切事情都是通过这个渠道进行的.我们可以通过检查响应来找出我们需要知道的一切
    /// 一种或另一种方式，我们必须调用 completionHandler, 需要快，尤其是因为我们可能在背景中被唤醒来处理这个问题
    /// 被称为允许您的应用知道用户为给定通知选择了哪个动作。 使用此方法执行与应用程序的自定义操作相关联的任务。当用户响应通知时，系统使用结果调用此方法。您可以使用此方法执行与该操作相关联的任务（如果有的话）。在执行结束时，您必须调用completionHandler块来让系统知道您已经处理了该通知。 您可以使用UNNotificationCategory和UNNotificationAction对象指定应用的通知类型和自定义操作。您可以在初始化时创建这些对象并将其注册到用户通知中心。即使您注册自定义操作，响应参数中的操作也可能表示用户在不执行任何操作的情况下解除了通知。 如果您不实现此方法，您的应用程序将不会响应自定义操作。

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let id = response.actionIdentifier // can be default, dismiss, or one of ours
        print("user action was: \(id)")

        if id == "snooze" {
            delay(2) { // because otherwise the image doesn't show
                self.createNotification()
            }
        }

        // if we need more info, we can also fetch response.notification

        // if this was text input, the response will be a UNTextInputNotificationAction

        if let textresponse = response as? UNTextInputNotificationResponse {
            let text = textresponse.userText
            print("user text was \(text)")
        }
        completionHandler()
    }

}


class LocalNotificationVC: UIViewController {

    @IBAction func doButton(_ sender: Any) {
        let del = UIApplication.shared.delegate as! AppDelegate
        del.notifHelper.kickThingsOff()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // pretend that we allow the user to set a reminder interval...
        // ... and that we permit the user to have a favorite interval
        // we can added that to our app's quick actions
        let subtitle = "In 1 hour..."
        let time = 60
        let item = UIApplicationShortcutItem(type: "coffee.schedule", localizedTitle: "Coffee Reminder", localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(templateImageName: "cup"), userInfo: ["time":time])
        UIApplication.shared.shortcutItems = [item]
        
    }
    
}
