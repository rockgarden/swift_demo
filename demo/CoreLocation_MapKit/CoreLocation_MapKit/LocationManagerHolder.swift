//
//  LocationManagerHolder.swift
//  CoreLocation_MapKit
//
//  Created by wangkan on 2016/12/1.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import CoreLocation

class LocationManagerHolder {
    let locman = CLLocationManager()
    var delegate : CLLocationManagerDelegate? {
        get {
            return self.locman.delegate
        }
        set {
            // set delegate _once_
            if self.locman.delegate == nil && newValue != nil {
                self.locman.delegate = newValue
                print("setting delegate!")
            }
        }
    }
    var doThisWhenAuthorized : (() -> ())?
    
    func checkForLocationAccess(always:Bool = false, andThen f: (()->())? = nil) {
        // no services? fail but try get alert
        guard CLLocationManager.locationServicesEnabled() else {
            print("no location services")
            self.locman.startUpdatingLocation()
            return
        }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            f?()
        case .notDetermined:
            self.doThisWhenAuthorized = f
            always ?
                self.locman.requestAlwaysAuthorization() :
                self.locman.requestWhenInUseAuthorization()
        case .restricted:
            // do nothing
            break
        case .denied:
            print("denied")
            // do nothing, or beg the user to authorize us in Settings
            break
        }
    }
    
}
