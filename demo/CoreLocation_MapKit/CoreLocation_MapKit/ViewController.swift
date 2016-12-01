//
//  ViewController.swift
//  CoreLocation_MapKit
//
//  Created by wangkan on 16/8/17.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    /// 是否延时获取位置信息: 1 = true use startUpdatingLocation() or 2 = false use requestLocation()
    let which = 1
    
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
	@IBOutlet weak var myMap: MKMapView!
    @IBOutlet var headingLab : UILabel!
    @IBOutlet weak var meTv: UITextView!

    let managerHolder = LocationManagerHolder()
    var locationManager : CLLocationManager {
        return self.managerHolder.locman
    } //相当于: let locationManager = CLLocationManager()
    
	var myLatitude: CLLocationDegrees!
	var myLongitude: CLLocationDegrees!
	var finalLatitude: CLLocationDegrees!
	var finalLongitude: CLLocationDegrees!
	var distance: CLLocationDistance!
    var updating = false
    var startTime : Date!
    var trying = false
    let deferInterval : TimeInterval = 5 //15*60
    var s = ""
    fileprivate var set = NSMutableArray()
    let REQ_ACC : CLLocationAccuracy = 10
    let REQ_TIME : TimeInterval = 10

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.managerHolder.delegate = self //相当于: locationManager.delegate = self
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        LocationMe(nil)

		let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        self.myMap.delegate = self
		myMap.addGestureRecognizer(tap)
	}
    
    func LocationMe (_ sender: Any!) {
        self.managerHolder.checkForLocationAccess {
            switch self.which {
            case 1:
                if self.trying { return }
                self.trying = true
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.activityType = .fitness //位置更新-行人模式
                self.startTime = nil
                print("starting")
                self.locationManager.startUpdatingLocation()
            case 2:
                print("requesting")
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest //kCLLocationAccuracyNearestTenMeters
                self.locationManager.requestLocation()
            default: break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        debugPrint("did change auth: \(status.rawValue)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.managerHolder.doThisWhenAuthorized?()
            self.managerHolder.doThisWhenAuthorized = nil
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Error while updating location " + error.localizedDescription)
        self.doStop(nil)
        self.stopTrying()
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if let error = error {
            showInfo(error)
        }
        let state = UIApplication.shared.applicationState
        if state == .background {
            if CLLocationManager.deferredLocationUpdatesAvailable() {
                showInfo("deferring")
                self.locationManager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: self.deferInterval)
            } else {
                showInfo("not able to defer")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("did update location ")
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                self.showInfo("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                debugPrint("Problem with the data received from geocoder")
            }
        })
        
        let loc = locations.last!
        let acc = loc.horizontalAccuracy
        let time = loc.timestamp
        let coord = loc.coordinate
        showInfo("\(Date()): Accuracy \(acc): You are at \(coord.latitude) \(coord.longitude)")
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            let ok = CLLocationManager.deferredLocationUpdatesAvailable()
            showInfo("deferred possible? \(ok)")
        }
        
        switch which {
        case 1:
            if self.startTime == nil {
                self.startTime = Date()
                break // ignore first attempt
            }
            print(acc)
            let elapsed = time.timeIntervalSince(self.startTime)
            if elapsed > REQ_TIME {
                print("This is taking too long")
                self.stopTrying() //why: stop 省电?!
                break
            }
            if acc < 0 || acc > REQ_ACC {
                break // wait for the next one
            }
            latitude.text = String(coord.latitude)
            longitude.text = String(coord.longitude)
            print("You are at \(coord.latitude) \(coord.longitude)")
            self.stopTrying()
        case 2:
            latitude.text = String(coord.latitude)
            longitude.text = String(coord.longitude)
            print("The quick way: You are at \(coord.latitude) \(coord.longitude)")
        // bug: can be called twice in quick succession
        default: break
        }
        
    }

	func action(_ gestureRecognizer: UIGestureRecognizer) {
		let touchPoint = gestureRecognizer.location(in: self.myMap)
		let newCoord: CLLocationCoordinate2D = myMap.convert(touchPoint, toCoordinateFrom: self.myMap)
		let getLat: CLLocationDegrees = newCoord.latitude
		let getLon: CLLocationDegrees = newCoord.longitude

		// Convert to points to CLLocation. In this way we can measure distanceFromLocation
		let newCoord2 = CLLocation(latitude: getLat, longitude: getLon)
		let newCoord3 = CLLocation(latitude: myLatitude, longitude: myLongitude)

		finalLatitude = newCoord2.coordinate.latitude
		finalLongitude = newCoord2.coordinate.longitude
		debugPrint("Original Latitude: \(myLatitude)")
		debugPrint("Original Longitude: \(myLongitude)")
		debugPrint("Final Latitude: \(finalLatitude)")
		debugPrint("Final Longitude: \(finalLongitude)")

		// distance between our position and the new point created
		let distance = newCoord2.distance(from: newCoord3)
		debugPrint("Distance between two points: \(distance)")

		let newAnnotation = MKPointAnnotation()
		newAnnotation.coordinate = newCoord
		newAnnotation.title = "My target"
		newAnnotation.subtitle = ""
		myMap.addAnnotation(newAnnotation)
	}

	func displayLocationInfo(_ placemark: CLPlacemark?) {
		if let containsPlacemark = placemark {
			// stop updating location to save battery life
			//locationManager.stopUpdatingLocation()

			// get data from placemark
			let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
			let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
			let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
			let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
			myLongitude = (containsPlacemark.location!.coordinate.longitude)
			myLatitude = (containsPlacemark.location!.coordinate.latitude)

			// testing show data
			debugPrint("Locality: \(locality)")
			debugPrint("PostalCode: \(postalCode)")
			debugPrint("Area: \(administrativeArea)")
			debugPrint("Country: \(country)")
			debugPrint(myLatitude)
			debugPrint(myLongitude)

			// update map with my location
			let theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
			let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: myLatitude, longitude: myLongitude)
			let theRegion: MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)

			myMap.setRegion(theRegion, animated: true)
		}
	}

	// distance between two points
	func degreesToRadians(_ degrees: Double) -> Double { return degrees * M_PI / 180.0 }
    
	func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / M_PI }

	func getBearingBetweenTwoPoints1(_ point1: CLLocation, point2: CLLocation) -> Double {
		let lat1 = degreesToRadians(point1.coordinate.latitude)
		let lon1 = degreesToRadians(point1.coordinate.longitude)
		let lat2 = degreesToRadians(point2.coordinate.latitude);
		let lon2 = degreesToRadians(point2.coordinate.longitude);

		debugPrint("Start latitude: \(point1.coordinate.latitude)")
		debugPrint("Start longitude: \(point1.coordinate.longitude)")
		debugPrint("Final latitude: \(point2.coordinate.latitude)")
		debugPrint("Final longitude: \(point2.coordinate.longitude)")

		let dLon = lon2 - lon1;
		let y = sin(dLon) * cos(lat2);
		let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
		let radiansBearing = atan2(y, x);

		return radiansToDegrees(radiansBearing)
	}
    
    fileprivate func showInfo(_ s: Any) {
        self.s = self.s + "\n" + String(describing:s)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    @IBAction func createAnotation(_ sender: AnyObject) {
        let a = MyAnotation(c: myMap.centerCoordinate, t: "Center", st: "The map center")
        _ = mapView(myMap, viewFor: a)
        myMap.addAnnotation(a)
        set.add(a)
    }
    
    @IBAction func deleteAnotation(_ sender: AnyObject) {
        //new for swift 2.0
        let annotationsToRemove = self.myMap.annotations
        self.myMap.removeAnnotations(annotationsToRemove)
    }
    
    @IBAction func coordinates(_ sender: AnyObject) {
        latitude.text = "\(myMap.centerCoordinate.latitude)"
        longitude.text = "\(myMap.centerCoordinate.longitude)"
    }
    
    @objc(mapView:viewForAnnotation:) func mapView(_ mapView: MKMapView, viewFor annotation:
        MKAnnotation) -> MKAnnotationView?{
        let pinView:MKPinAnnotationView = MKPinAnnotationView(annotation:
            annotation, reuseIdentifier: "Custom")
        //purple color to anotation
        //pinView.pinColor = MKPinAnnotationColor.Purple
        pinView.image = UIImage(named:"mypin.png")
        return pinView
    }

}

//MARK: - Heading
extension ViewController {

    @IBAction func doStart (_ sender: Any!) {
        guard CLLocationManager.headingAvailable() else {return} // no hardware
        if self.updating {doStop(nil); return}
        if self.locationManager.delegate == nil {self.locationManager.delegate = self}

        debugPrint("starting")
        self.locationManager.headingFilter = 5
        self.locationManager.headingOrientation = .portrait
        self.updating = true
        // NO AUTH NEEDED!
        // the heading part works just fine even if Location Services is turned off
        // and if it is turned on, we will get true-north
        // seems like a major bug to me
        self.locationManager.startUpdatingHeading()
    }

    func doStop (_ sender: Any!) {
        self.locationManager.stopUpdatingHeading()
        self.headingLab.text = ""
        self.updating = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var h = newHeading.magneticHeading
        let h2 = newHeading.trueHeading // -1 if no location info
        debugPrint("\(h) \(h2) ")
        if h2 >= 0 {
            h = h2
        }
        let cards = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        var dir = "N"
        for (ix, card) in cards.enumerated() {
            if h < 45.0/2.0 + 45.0*Double(ix) {
                dir = card
                break
            }
        }
        if self.headingLab.text != dir {
            self.headingLab.text = dir
        }
        debugPrint(dir)
    }

    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        debugPrint("he asked me, he asked me")
        return true // if you want the calibration dialog to be able to appear
    }

}

//MARK: - Findme
/*
 只有在init时才有输出
 allowDeferredLocationUpdatesUntilTraveled 延迟位置更新
 必须iPhone5以及之后的硬件设备才支持
 desiredAccuracy必须设置为kCLLocationAccuracyBest或者kCLLocationAccuracyBestForNavigation
 distanceFilter必须设置为kCLDistanceFilterNone
 只在APP运行在后台时生效 前台运行时是不会进行延迟处理的
 只有系统在低功耗(Low Power State)的时候才有可能生效
 */
extension ViewController {
    
    @IBAction func doFindMe (_ sender: Any!) {
        self.managerHolder.checkForLocationAccess {
            if self.trying { self.stopTrying(); return }
            self.trying = true
            self.meTv.isHidden = false
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.activityType = .other //位置更新-未知模式，默认为此
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.startTime = nil
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.showInfo("starting")
            self.locationManager.startUpdatingLocation()
            self.s = ""
            self.meTv.text = ""
            var ob : Any = ""
            ob = NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) {
                _ in
                NotificationCenter.default.removeObserver(ob)
                if CLLocationManager.deferredLocationUpdatesAvailable() {
                    self.showInfo("going into background: deferring")
                    self.locationManager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: self.deferInterval)
                } else {
                    self.showInfo("going into background but couldn't defer")
                }
            }
        }
    }
    
    func stopTrying () {
        self.locationManager.stopUpdatingLocation()
        self.startTime = nil
        self.trying = false
        self.meTv.text = self.s
        self.meTv.isHidden = true
    }
    
}

