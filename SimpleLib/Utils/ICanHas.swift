//
// ICanHas.swift
//
// Modified by wangkan on 16/5/8.
//
// Copyright (c) 21/12/15. Rockgarden Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit
import CoreLocation
import AVFoundation
import Photos
import AddressBookUI
import EventKit

open class ICanHas {
    
    fileprivate class func onMain(_ closure:@escaping ()->Void) {
        DispatchQueue.main.async(execute: closure)
    }
    
    static var didTryToRegisterForPush = false
    
    static var isHasingPush = false
    static var isHasingLocation = false
    static var isHasingCapture:[String:Bool] = [AVMediaTypeAudio:false,AVMediaTypeClosedCaption:false,AVMediaTypeMetadata:false,AVMediaTypeMuxed:false,AVMediaTypeSubtitle:false,AVMediaTypeText:false,AVMediaTypeTimecode:false,AVMediaTypeVideo:false]
    static var isHasingPhotos = false
    static var isHasingContacts = false
    static var isHasingCalendar:[EKEntityType:Bool] = [EKEntityType.event:false,EKEntityType.reminder:false]
    
    static var hasPushClosures:[(_ authorized:Bool)->Void] = []
    static var hasLocationClosures:[(_ authorized:Bool, _ status:CLAuthorizationStatus, _ denied:Bool)->Void] = []
    static var hasCaptureClosures:[String:[(_ authorized:Bool,_ status:AVAuthorizationStatus)->Void]] = [AVMediaTypeAudio:[],AVMediaTypeClosedCaption:[],AVMediaTypeMetadata:[],AVMediaTypeMuxed:[],AVMediaTypeSubtitle:[],AVMediaTypeText:[],AVMediaTypeTimecode:[],AVMediaTypeVideo:[]]
    static var hasPhotosClosures:[(_ authorized:Bool,_ status:PHAuthorizationStatus)->Void] = []
    static var hasContactsClosures:[(_ authorized:Bool,_ status:ABAuthorizationStatus,_ error:CFError?)->Void] = []
    static var hasCalendarClosures:[EKEntityType:[(_ authorized:Bool,_ error:NSError?)->Void]] = [EKEntityType.event:[],EKEntityType.reminder:[]]
    
    open class func CalendarAuthorizationStatus(entityType type:EKEntityType = EKEntityType.event)->EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: type)
    }
    
    open class func CalendarAuthorization(entityType type:EKEntityType = EKEntityType.event)->Bool {
        return EKEventStore.authorizationStatus(for: type) == .authorized
    }
    
    open class func Calendar(_ store:EKEventStore = EKEventStore(), entityType type:EKEntityType = EKEntityType.event, closure:@escaping (_ authorized:Bool,_ error:NSError?)->Void) {
        onMain {
            ICanHas.hasCalendarClosures[type]!.append(closure)
            if !ICanHas.isHasingCalendar[type]! {
                ICanHas.isHasingCalendar[type] = true
                let done = {
                    (authorized:Bool,error:NSError!)->Void in
                    let array = ICanHas.hasCalendarClosures[type]!
                    ICanHas.hasCalendarClosures[type] = []
                    let _ = array.map{$0(authorized,error)}
                    ICanHas.isHasingCalendar[type] = false
                }
                
                store.requestAccess(to: type, completion: { (authorized:Bool, error:NSError?) -> Void in
                    ICanHas.onMain {
                        done(authorized)
                    }
                } as! EKEventStoreRequestAccessCompletionHandler)
            }
        }
    }
    
    open class func ContactsAuthorizationStatus()->ABAuthorizationStatus {
        return ABAddressBookGetAuthorizationStatus()
    }
    
    open class func ContactsAuthorization()->Bool {
        return ABAddressBookGetAuthorizationStatus() == .authorized
    }
    
    open class func Contacts(_ addressBook:ABAddressBook? = ABAddressBookCreateWithOptions(nil, nil)?.takeRetainedValue(), closure:@escaping (_ authorized:Bool,_ status:ABAuthorizationStatus,_ error:CFError?)->Void) {
        
        onMain {
            
            ICanHas.hasContactsClosures.append(closure)
            
            if !ICanHas.isHasingContacts {
                ICanHas.isHasingContacts = true
                let done = {
                    (authorized:Bool,status:ABAuthorizationStatus,error:CFError!)->Void in
                    
                    let array = ICanHas.hasContactsClosures
                    ICanHas.hasContactsClosures = []
                    
                    let _ = array.map{$0(authorized,status,error)}
                    
                    ICanHas.isHasingContacts = false
                }
                
                let currentStatus = ABAddressBookGetAuthorizationStatus()
                
                switch currentStatus {
                case .denied:
                    done(false,currentStatus,nil)
                case .restricted:
                    done(false,currentStatus,nil)
                case .authorized:
                    done(true,currentStatus,nil)
                case .notDetermined:
                    ABAddressBookRequestAccessWithCompletion(addressBook, { (authorized:Bool, error:CFError!) -> Void in
                        
                        ICanHas.onMain {
                            done(authorized,ABAddressBookGetAuthorizationStatus(),error)
                        }
                        
                    })
                }
                
                
            }
            
        }
        
    }
    
    open class func PhotosAuthorizationStatus()->PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    open class func PhotosAuthorization()->Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    open class func Photos(_ closure:@escaping (_ authorized:Bool,_ status:PHAuthorizationStatus)->Void) {
        
        onMain {
            
            ICanHas.hasPhotosClosures.append(closure)
            
            if !ICanHas.isHasingPhotos {
                ICanHas.isHasingPhotos = true
                
                let done = {
                    (authorized:Bool,status:PHAuthorizationStatus) -> Void in
                    
                    let array = ICanHas.hasPhotosClosures
                    ICanHas.hasPhotosClosures = []
                    
                    let _ = array.map{$0(authorized,status)}
                    
                    ICanHas.isHasingPhotos = false
                }
                
                let currentStatus = PHPhotoLibrary.authorizationStatus()
                
                switch currentStatus {
                case .denied:
                    done(false,currentStatus)
                case .restricted:
                    done(false,currentStatus)
                case .authorized:
                    done(true,currentStatus)
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) -> Void in
                        
                        ICanHas.onMain {
                            done(status == PHAuthorizationStatus.authorized, status)
                        }
                        
                        
                        
                    })
                }
            }
            
            
            
        }
        
    }
    
    open class func CaptureAuthorizationStatus(_ type:String = AVMediaTypeVideo)->AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(forMediaType: type)
    }
    
    open class func CaptureAuthorization(_ type:String = AVMediaTypeVideo)->Bool {
        return AVCaptureDevice.authorizationStatus(forMediaType: type) == .authorized
    }
    
    open class func Capture(_ type:String = AVMediaTypeVideo,closure:@escaping (_ authorized:Bool,_ status:AVAuthorizationStatus)->Void) {
        onMain {
            
            ICanHas.hasCaptureClosures[type]!.append(closure)
            
            if !ICanHas.isHasingCapture[type]! {
                ICanHas.isHasingCapture[type] = true
                
                let done = {
                    (authorized:Bool,status:AVAuthorizationStatus) -> Void in
                    
                    let array = ICanHas.hasCaptureClosures[type]!
                    ICanHas.hasCaptureClosures[type] = []
                    
                    let _ = array.map{$0(authorized,status)}
                    
                    ICanHas.isHasingCapture[type] = false
                }
                
                let currentStatus = AVCaptureDevice.authorizationStatus(forMediaType: type)
                
                switch currentStatus {
                case .denied:
                    done(false,currentStatus)
                case .restricted:
                    done(false,currentStatus)
                case .authorized:
                    done(true,currentStatus)
                case .notDetermined:
                    AVCaptureDevice.requestAccess(forMediaType: type, completionHandler: { (authorized:Bool) -> Void in
                        
                        ICanHas.onMain {
                            done(authorized,AVCaptureDevice.authorizationStatus(forMediaType: type))
                        }
                        
                        
                    })
                }
                
            }
            
        }
    }
    
    open class func PushAuthorization()->Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    //    private static var pushExchangeDone = false
    
    open class func Push(_ types:UIUserNotificationType = UIUserNotificationType.alert.union(UIUserNotificationType.badge).union(UIUserNotificationType.sound),closure:@escaping (_ authorized:Bool)->Void) {
        
        onMain {
            
            //                if !self.pushExchangeDone {
            //                    self.pushExchangeDone = true
            //
            //                    let appDelegate:NSObject = UIApplication.sharedApplication().delegate! as! NSObject
            //
            //                    let appDelegateClass:AnyClass = appDelegate.dynamicType
            //
            //                    [
            //                        ("application:didRegisterForRemoteNotificationsWithDeviceToken:","_ICanHas_application:didRegisterForRemoteNotificationsWithDeviceToken:"),
            //                        ("application:didFailToRegisterForRemoteNotificationsWithError:","_ICanHas_application:didFailToRegisterForRemoteNotificationsWithError:")
            //                        ]
            //                        .map {
            //
            //                            (pair:(String,String))->Void in
            //
            //                            if String.fromCString(method_getTypeEncoding(class_getInstanceMethod(appDelegateClass, Selector(stringLiteral: pair.0)))) == nil {
            //
            //                                let method = class_getInstanceMethod(NSObject.self, Selector(stringLiteral:"_ICanHas_empty_" + pair.0))
            //
            //                                class_addMethod(appDelegateClass, Selector(stringLiteral:pair.0), method_getImplementation(method), method_getTypeEncoding(method))
            //
            //                            }
            //
            //
            //                            method_exchangeImplementations(
            //                                class_getInstanceMethod(appDelegateClass,Selector(stringLiteral: pair.0)),
            //                                class_getInstanceMethod(appDelegateClass,Selector(stringLiteral: pair.1))
            //                            )
            //                    }
            //
            //                    appDelegate._ich_listener = _ICanHasListener()
            //                }
            
            ICanHas.hasPushClosures.append(closure)
            
            if !ICanHas.isHasingPush {
                ICanHas.isHasingPush = true
                
                let done = {
                    (authorized:Bool) -> Void in
                    
                    let array = ICanHas.hasPushClosures
                    ICanHas.hasPushClosures = []
                    
                    let _ = array.map{$0(authorized)}
                    
                    ICanHas.isHasingPush = false
                }
                
                let application:UIApplication! = UIApplication.shared
                
                if ICanHas.didTryToRegisterForPush {
                    done(application.isRegisteredForRemoteNotifications)
                }else {
                    ICanHas.didTryToRegisterForPush = true
                    
                    application.registerUserNotificationSettings(UIUserNotificationSettings(types: types, categories: nil))
                    
                    var bgNoteObject:NSObjectProtocol? = nil
                    var fgNoteObject:NSObjectProtocol? = nil
                    
                    var hasTimedOut = false
                    
                    var hasGoneToBG = false
                    
                    var shouldWaitForFG = false
                    
                    bgNoteObject = bgNoteObject ?? NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: OperationQueue.main) { (note:Notification) -> Void in
                        
                        hasGoneToBG = true
                        
                        if !hasTimedOut {
                            shouldWaitForFG = true
                        }
                        
                        bgNoteObject = nil
                    }
                    
                    fgNoteObject = fgNoteObject ?? NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main) { (note:Notification) -> Void in
                        
                        if shouldWaitForFG {
                            done(application.isRegisteredForRemoteNotifications)
                        }
                        
                        fgNoteObject = nil
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        hasTimedOut = true
                        if !hasGoneToBG {
                            done(application.isRegisteredForRemoteNotifications)
                        }
                    })
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    fileprivate static var locationExchangeDone:[String:Bool] = [:]
    
    open class func LocationAuthorizationStatus()->CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    open class func LocationAuthorization(_ background:Bool = false)->Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways || (!background && CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
    }
    
    /**
     检查与申请定位权限
     
     - parameter background: 是否允许后台定位
     - parameter mngr:       CLLocationManager
     - parameter closure:    是否授权/授权状态/是否允许
     */
    open class func Location(_ background:Bool = false, manager mngr:CLLocationManager? = nil, closure:@escaping (_ authorized:Bool,_ status:CLAuthorizationStatus, _ denied:Bool) -> Void) {
        onMain {
            ICanHas.hasLocationClosures.append(closure)
            let currentStatus = CLLocationManager.authorizationStatus()
            
            if !ICanHas.isHasingLocation {
                ICanHas.isHasingLocation = true
                let done = {
                    (authorized: Bool, status: CLAuthorizationStatus, denied:Bool) -> Void in
                    let array = ICanHas.hasLocationClosures
                    ICanHas.hasLocationClosures = []
                    let _ = array.map{$0(authorized, status, denied)}
                    ICanHas.isHasingLocation = false
                }
                
                let callback = {(authorized:Bool, denied:Bool) -> Void in
                    done(authorized, currentStatus, denied)
                }
                
                switch currentStatus {
                case .authorizedAlways:
                    callback(true, false)
                case .denied:
                    callback(false, true)
                case .restricted:
                    callback(false, true )
                case .authorizedWhenInUse:
                    if background {
                        fallthrough
                    }else {
                        callback(true, false)
                    }
                case .notDetermined:
                    var manager:CLLocationManager! = mngr ?? CLLocationManager()
                    
                    //                    let managerDelegate:CLLocationManagerDelegate
                    //                    var retainedManagerDelegate:CLLocationManagerDelegate!
                    
                    //                    if manager.delegate == nil {
                    //                        managerDelegate = _ICanHasEmptyLocationDelegate()
                    //                        manager.delegate = managerDelegate
                    //                    } else {
                    //                        managerDelegate = manager.delegate!
                    //                    }
                    
                    //                    retainedManagerDelegate = managerDelegate
                    
                    //                    let _ = retainedManagerDelegate
                    
                    //                    let managerDelegateClass:AnyClass = (managerDelegate as AnyObject).dynamicType
                    
                    //                    let managerDelegateClassName = "\(managerDelegateClass)"
                    
                    //                    if !(self.locationExchangeDone[managerDelegateClassName] ?? false) {
                    //                        self.locationExchangeDone[managerDelegateClassName] = true
                    //
                    //                        let pair = ("locationManager:didChangeAuthorizationStatus:","_ICanHas_locationManager:didChangeAuthorizationStatus:")
                    //
                    //                        if String.fromCString(method_getTypeEncoding(class_getInstanceMethod(managerDelegateClass, Selector(stringLiteral: pair.0)))) == nil {
                    //
                    //                            let method = class_getInstanceMethod(NSObject.self, Selector(stringLiteral:"_ICanHas_empty_" + pair.0))
                    //
                    //                            class_addMethod(managerDelegateClass, Selector(stringLiteral:pair.0), method_getImplementation(method), method_getTypeEncoding(method))
                    //
                    //                        }
                    //
                    //
                    //                        method_exchangeImplementations(
                    //                            class_getInstanceMethod(managerDelegateClass,Selector(stringLiteral: pair.0)),
                    //                            class_getInstanceMethod(managerDelegateClass,Selector(stringLiteral: pair.1))
                    //                        )
                    //
                    //                    }
                    
                    //                    var listener:_ICanHasListener! = _ICanHasListener()
                    //                    var removeListener:(()->Void)! = nil
                    
                    var foregroundObject:NSObjectProtocol!
                    var backgroundObject:NSObjectProtocol!
                    
                    var completed = false
                    var hasTimedOut = false
                    var canTimeOut = true
                    
                    let complete:(Bool)->Void = {
                        worked in
                        //                        retainedObjects = nil
                        //                        listener = nil
                        if !completed {
                            completed = true
                            manager = nil
                            if let object = foregroundObject {
                                NotificationCenter.default.removeObserver(object)
                            }
                            if let object = backgroundObject {
                                NotificationCenter.default.removeObserver(object)
                            }
                            foregroundObject = nil
                            backgroundObject = nil
                            let status = CLLocationManager.authorizationStatus()
                            if status == .authorizedAlways || (!background && status == .authorizedWhenInUse) {
                                done(worked && true, status, false)
                            }else {
                                done(false, status, false)
                            }
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        if canTimeOut {
                            hasTimedOut = true
                            if let object = backgroundObject {
                                NotificationCenter.default.removeObserver(object)
                                backgroundObject = nil
                                complete(false)
                            }
                        }
                    })
                    
                    backgroundObject = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: nil) {
                        _ in
                        canTimeOut = false
                    }
                    
                    foregroundObject = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil) {
                        _ in
                        if !hasTimedOut {
                            complete(true)
                        }
                    }
                    
                    //                    if let delegate = manager.delegate {
                    //                        var lastDelegate:NSObject = delegate as! NSObject
                    //                        var retainedObjects:[AnyObject]! = []
                    //                        retainedObjects.append(lastDelegate)
                    //                        while lastDelegate._ich_listener != nil {
                    //                            lastDelegate = lastDelegate._ich_listener
                    //                            retainedObjects.append(lastDelegate)
                    //                        }
                    //                        lastDelegate._ich_listener = listener
                    //
                    //                    }else {
                    //                        manager.delegate = listener
                    //                        removeListener = {
                    //                            manager.delegate = nil
                    //                            listener = nil
                    //                            manager = nil
                    //                            removeListener = nil
                    //                        }
                    //                    }
                    
                    
                    //                    listener.changedLocationPermissions = {
                    //                        (status:CLAuthorizationStatus) -> Void in
                    //
                    //                        ICanHas.onMain {
                    //                            if status != .NotDetermined && status != currentStatus {
                    //
                    //                                removeListener()
                    //
                    //
                    //                            }
                    //                        }
                    //                    }
                    // 需要WhenInUse/Always权限的用户提示信息
                    if background {
                        assert(
                            Bundle.main.object(
                                forInfoDictionaryKey: "NSLocationAlwaysUsageDescription"
                                ) != nil,
                            "Make sure to add the key 'NSLocationAlwaysUsageDescription' to your info.plist file!"
                        )
                        manager.requestAlwaysAuthorization()
                    } else {
                        debugPrint("RIGHT NOW REQUESTING!!!!!", terminator: "")
                        assert(
                            Bundle.main.object(
                                forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription"
                                ) != nil,
                            "Make sure to add the key 'NSLocationWhenInUseUsageDescription' to your info.plist file!"
                        )
                        manager.requestWhenInUseAuthorization()
                    }
                }
            } else if (currentStatus.rawValue == 3) {
                
            }
        }
    }
}

private var _ICanHasListenerHandler: UInt8 = 0

extension NSObject {
    
    //    private var _ich_listener:_ICanHasListener! {
    //        set {
    //
    //            objc_setAssociatedObject(self, &_ICanHasListenerHandler, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    //        }
    //        get {
    //            return objc_getAssociatedObject(self, &_ICanHasListenerHandler) as? _ICanHasListener
    //        }
    //    }
    
    //    //Empty implementations:
    //Added implementations
    //    public func _ICanHas_empty_locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) { }
    
    //    public func _ICanHas_empty_application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) { }
    //
    //    public func _ICanHas_empty_application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) { }
    
    //Added implementations
    //    public func _ICanHas_locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    //        self._ich_listener!.locationManager(manager, didChangeAuthorizationStatus: status)
    //
    //        print("DID CHANGE BEING CALLED!!!!")
    //
    //        self._ICanHas_locationManager(manager, didChangeAuthorizationStatus: status)
    //    }
    
    //    public func _ICanHas_application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    //        self._ich_listener?.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    //
    //        self._ICanHas_application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    //    }
    //    
    //    public func _ICanHas_application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    //        self._ich_listener?.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    //        
    //        self._ICanHas_application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    //    }
    
}

//public class _ICanHasEmptyLocationDelegate:NSObject, CLLocationManagerDelegate {
//    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        
//        print("CHANGED AUTH STATUS")
//        
//    }
//}

//public class _ICanHasListener:NSObject,CLLocationManagerDelegate,UIApplicationDelegate {
//    var changedLocationPermissions:((CLAuthorizationStatus)->Void)!
//    var registeredForPush:((NSData)->Void)!
//    var failedToRegisterForPush:((NSError)->Void)!
//    
//    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        self.changedLocationPermissions?(status)
//    }
//    
////    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
////        self.registeredForPush?(deviceToken)
////    }
////    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
////        self.failedToRegisterForPush?(error)
////    }
//}
